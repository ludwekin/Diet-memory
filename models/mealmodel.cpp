#include "mealmodel.h"
#include <QDebug>

MealModel::MealModel(QObject *parent)
    : QAbstractListModel(parent)
    , m_database(new MealDatabase(this))
{
    if (!m_database->initDatabase()) {
        qDebug() << "Failed to initialize database";
        emit errorOccurred("数据库初始化失败");
    }
    
    // Load today's meals by default
    loadMealsForDate(QDate::currentDate());
}

int MealModel::rowCount(const QModelIndex &parent) const
{
    if (parent.isValid())
        return 0;
    return m_meals.size();
}

QVariant MealModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid() || index.row() >= m_meals.size())
        return QVariant();

    const MealRecord &meal = m_meals.at(index.row());

    switch (role) {
    case IdRole:
        return meal.id;
    case NameRole:
        return meal.name;
    case MealTypeRole:
        return meal.mealType;
    case PriceRole:
        return meal.price;
    case ImagePathRole:
        return meal.imagePath;
    case DateTimeRole:
        return meal.dateTime;
    case NotesRole:
        return meal.notes;
    case DateRole:
        return meal.dateTime.date();
    case TimeRole:
        return meal.dateTime.time();
    default:
        return QVariant();
    }
}

QHash<int, QByteArray> MealModel::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[IdRole] = "id";
    roles[NameRole] = "name";
    roles[MealTypeRole] = "mealType";
    roles[PriceRole] = "price";
    roles[ImagePathRole] = "imagePath";
    roles[DateTimeRole] = "dateTime";
    roles[NotesRole] = "notes";
    roles[DateRole] = "date";
    roles[TimeRole] = "time";
    return roles;
}

void MealModel::loadMealsForDate(const QDate &date)
{
    QList<MealRecord> meals = m_database->getMealsByDate(date);
    setMeals(meals);
}

void MealModel::loadMealsForDateRange(const QDate &startDate, const QDate &endDate)
{
    QList<MealRecord> meals = m_database->getMealsByDateRange(startDate, endDate);
    setMeals(meals);
}

void MealModel::loadAllMeals()
{
    QList<MealRecord> meals = m_database->getAllMeals();
    setMeals(meals);
}

void MealModel::addMeal(const QString &name, const QString &mealType, double price,
                        const QString &imagePath, const QDateTime &dateTime, const QString &notes)
{
    MealRecord meal;
    meal.name = name;
    meal.mealType = mealType;
    meal.price = price;
    meal.imagePath = imagePath;
    meal.dateTime = dateTime;
    meal.notes = notes;

    if (m_database->addMeal(meal)) {
        // Reload meals for the current date
        loadMealsForDate(dateTime.date());
        emit dataChanged();
    } else {
        emit errorOccurred("添加餐食失败");
    }
}

void MealModel::updateMeal(int id, const QString &name, const QString &mealType, double price,
                           const QString &imagePath, const QDateTime &dateTime, const QString &notes)
{
    MealRecord meal;
    meal.id = id;
    meal.name = name;
    meal.mealType = mealType;
    meal.price = price;
    meal.imagePath = imagePath;
    meal.dateTime = dateTime;
    meal.notes = notes;

    if (m_database->updateMeal(meal)) {
        // Reload meals for the current date
        loadMealsForDate(dateTime.date());
        emit dataChanged();
    } else {
        emit errorOccurred("更新餐食失败");
    }
}

void MealModel::deleteMeal(int id)
{
    if (m_database->deleteMeal(id)) {
        // Find the meal to get its date for reloading
        QDate mealDate;
        for (const MealRecord &meal : m_meals) {
            if (meal.id == id) {
                mealDate = meal.dateTime.date();
                break;
            }
        }
        
        if (mealDate.isValid()) {
            loadMealsForDate(mealDate);
        }
        emit dataChanged();
    } else {
        emit errorOccurred("删除餐食失败");
    }
}

double MealModel::getTotalSpentForDate(const QDate &date)
{
    return m_database->getTotalSpentByDate(date);
}

double MealModel::getTotalSpentForDateRange(const QDate &startDate, const QDate &endDate)
{
    return m_database->getTotalSpentByDateRange(startDate, endDate);
}

void MealModel::refresh()
{
    if (!m_meals.isEmpty()) {
        QDate currentDate = m_meals.first().dateTime.date();
        loadMealsForDate(currentDate);
    }
}

void MealModel::setMeals(const QList<MealRecord> &meals)
{
    beginResetModel();
    m_meals = meals;
    endResetModel();
} 