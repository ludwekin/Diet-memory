#ifndef MEALDATABASE_H
#define MEALDATABASE_H

#include <QObject>
#include <QSqlDatabase>
#include <QSqlQuery>
#include <QSqlError>
#include <QVariant>
#include <QDateTime>
#include <QString>
#include <QList>

struct MealRecord {
    int id;
    QString name;
    QString mealType; // breakfast, lunch, dinner
    double price;
    QString imagePath;
    QDateTime dateTime;
    QString notes;
};

class MealDatabase : public QObject
{
    Q_OBJECT

public:
    explicit MealDatabase(QObject *parent = nullptr);
    ~MealDatabase();

    bool initDatabase();
    bool addMeal(const MealRecord &meal);
    bool updateMeal(const MealRecord &meal);
    bool deleteMeal(int id);
    QList<MealRecord> getMealsByDate(const QDate &date);
    QList<MealRecord> getMealsByDateRange(const QDate &startDate, const QDate &endDate);
    QList<MealRecord> getAllMeals();
    double getTotalSpentByDate(const QDate &date);
    double getTotalSpentByDateRange(const QDate &startDate, const QDate &endDate);

private:
    QSqlDatabase m_database;
    bool createTables();
};

#endif // MEALDATABASE_H 