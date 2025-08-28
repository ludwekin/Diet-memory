#include "mealdatabase.h"
#include <QStandardPaths>
#include <QDir>
#include <QDebug>
#include <QDate>

MealDatabase::MealDatabase(QObject *parent)
    : QObject(parent)
{
}

MealDatabase::~MealDatabase()
{
    if (m_database.isOpen()) {
        m_database.close();
    }
}

bool MealDatabase::initDatabase()
{
    QString dbPath = QStandardPaths::writableLocation(QStandardPaths::AppDataLocation);
    QDir().mkpath(dbPath);
    
    m_database = QSqlDatabase::addDatabase("QSQLITE");
    m_database.setDatabaseName(dbPath + "/meals.db");
    
    if (!m_database.open()) {
        qDebug() << "Failed to open database:" << m_database.lastError().text();
        return false;
    }
    
    return createTables();
}

bool MealDatabase::createTables()
{
    QSqlQuery query;
    QString createTableSql = 
        "CREATE TABLE IF NOT EXISTS meals ("
        "id INTEGER PRIMARY KEY AUTOINCREMENT,"
        "name TEXT NOT NULL,"
        "meal_type TEXT NOT NULL,"
        "price REAL NOT NULL,"
        "image_path TEXT,"
        "date_time TEXT NOT NULL,"
        "notes TEXT"
        ")";
    
    if (!query.exec(createTableSql)) {
        qDebug() << "Failed to create table:" << query.lastError().text();
        return false;
    }
    
    return true;
}

bool MealDatabase::addMeal(const MealRecord &meal)
{
    QSqlQuery query;
    query.prepare(
        "INSERT INTO meals (name, meal_type, price, image_path, date_time, notes) "
        "VALUES (?, ?, ?, ?, ?, ?)"
    );
    
    query.addBindValue(meal.name);
    query.addBindValue(meal.mealType);
    query.addBindValue(meal.price);
    query.addBindValue(meal.imagePath);
    query.addBindValue(meal.dateTime.toString(Qt::ISODate));
    query.addBindValue(meal.notes);
    
    if (!query.exec()) {
        qDebug() << "Failed to add meal:" << query.lastError().text();
        return false;
    }
    
    return true;
}

bool MealDatabase::updateMeal(const MealRecord &meal)
{
    QSqlQuery query;
    query.prepare(
        "UPDATE meals SET name=?, meal_type=?, price=?, image_path=?, date_time=?, notes=? "
        "WHERE id=?"
    );
    
    query.addBindValue(meal.name);
    query.addBindValue(meal.mealType);
    query.addBindValue(meal.price);
    query.addBindValue(meal.imagePath);
    query.addBindValue(meal.dateTime.toString(Qt::ISODate));
    query.addBindValue(meal.notes);
    query.addBindValue(meal.id);
    
    if (!query.exec()) {
        qDebug() << "Failed to update meal:" << query.lastError().text();
        return false;
    }
    
    return true;
}

bool MealDatabase::deleteMeal(int id)
{
    QSqlQuery query;
    query.prepare("DELETE FROM meals WHERE id = ?");
    query.addBindValue(id);
    
    if (!query.exec()) {
        qDebug() << "Failed to delete meal:" << query.lastError().text();
        return false;
    }
    
    return true;
}

QList<MealRecord> MealDatabase::getMealsByDate(const QDate &date)
{
    QList<MealRecord> meals;
    QSqlQuery query;
    query.prepare(
        "SELECT id, name, meal_type, price, image_path, date_time, notes "
        "FROM meals WHERE DATE(date_time) = DATE(?) ORDER BY date_time"
    );
    query.addBindValue(date.toString(Qt::ISODate));
    
    if (query.exec()) {
        while (query.next()) {
            MealRecord meal;
            meal.id = query.value(0).toInt();
            meal.name = query.value(1).toString();
            meal.mealType = query.value(2).toString();
            meal.price = query.value(3).toDouble();
            meal.imagePath = query.value(4).toString();
            meal.dateTime = QDateTime::fromString(query.value(5).toString(), Qt::ISODate);
            meal.notes = query.value(6).toString();
            meals.append(meal);
        }
    }
    
    return meals;
}

QList<MealRecord> MealDatabase::getMealsByDateRange(const QDate &startDate, const QDate &endDate)
{
    QList<MealRecord> meals;
    QSqlQuery query;
    query.prepare(
        "SELECT id, name, meal_type, price, image_path, date_time, notes "
        "FROM meals WHERE DATE(date_time) BETWEEN DATE(?) AND DATE(?) ORDER BY date_time"
    );
    query.addBindValue(startDate.toString(Qt::ISODate));
    query.addBindValue(endDate.toString(Qt::ISODate));
    
    if (query.exec()) {
        while (query.next()) {
            MealRecord meal;
            meal.id = query.value(0).toInt();
            meal.name = query.value(1).toString();
            meal.mealType = query.value(2).toString();
            meal.price = query.value(3).toDouble();
            meal.imagePath = query.value(4).toString();
            meal.dateTime = QDateTime::fromString(query.value(5).toString(), Qt::ISODate);
            meal.notes = query.value(6).toString();
            meals.append(meal);
        }
    }
    
    return meals;
}

QList<MealRecord> MealDatabase::getAllMeals()
{
    QList<MealRecord> meals;
    QSqlQuery query("SELECT id, name, meal_type, price, image_path, date_time, notes FROM meals ORDER BY date_time DESC");
    
    if (query.exec()) {
        while (query.next()) {
            MealRecord meal;
            meal.id = query.value(0).toInt();
            meal.name = query.value(1).toString();
            meal.mealType = query.value(2).toString();
            meal.price = query.value(3).toDouble();
            meal.imagePath = query.value(4).toString();
            meal.dateTime = QDateTime::fromString(query.value(5).toString(), Qt::ISODate);
            meal.notes = query.value(6).toString();
            meals.append(meal);
        }
    }
    
    return meals;
}

double MealDatabase::getTotalSpentByDate(const QDate &date)
{
    QSqlQuery query;
    query.prepare("SELECT SUM(price) FROM meals WHERE DATE(date_time) = DATE(?)");
    query.addBindValue(date.toString(Qt::ISODate));
    
    if (query.exec() && query.next()) {
        return query.value(0).toDouble();
    }
    
    return 0.0;
}

double MealDatabase::getTotalSpentByDateRange(const QDate &startDate, const QDate &endDate)
{
    QSqlQuery query;
    query.prepare("SELECT SUM(price) FROM meals WHERE DATE(date_time) BETWEEN DATE(?) AND DATE(?)");
    query.addBindValue(startDate.toString(Qt::ISODate));
    query.addBindValue(endDate.toString(Qt::ISODate));
    
    if (query.exec() && query.next()) {
        return query.value(0).toDouble();
    }
    
    return 0.0;
} 