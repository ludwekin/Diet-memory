#ifndef MEALMODEL_H
#define MEALMODEL_H

#include <QObject>
#include <QAbstractListModel>
#include <QList>
#include <QDate>
#include <QDateTime>
#include <QString>
#include <QVariant>
#include <QHash>
#include <QByteArray>
#include "../database/mealdatabase.h"

class MealModel : public QAbstractListModel
{
    Q_OBJECT

public:
    enum MealRoles {
        IdRole = Qt::UserRole + 1,
        NameRole,
        MealTypeRole,
        PriceRole,
        ImagePathRole,
        DateTimeRole,
        NotesRole,
        DateRole,
        TimeRole
    };

    explicit MealModel(QObject *parent = nullptr);

    // QAbstractListModel interface
    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;
    QHash<int, QByteArray> roleNames() const override;

    // Public methods
    Q_INVOKABLE void loadMealsForDate(const QDate &date);
    Q_INVOKABLE void loadMealsForDateRange(const QDate &startDate, const QDate &endDate);
    Q_INVOKABLE void loadAllMeals();
    Q_INVOKABLE void addMeal(const QString &name, const QString &mealType, double price, 
                             const QString &imagePath, const QDateTime &dateTime, const QString &notes);
    Q_INVOKABLE void updateMeal(int id, const QString &name, const QString &mealType, double price,
                                const QString &imagePath, const QDateTime &dateTime, const QString &notes);
    Q_INVOKABLE void deleteMeal(int id);
    Q_INVOKABLE double getTotalSpentForDate(const QDate &date);
    Q_INVOKABLE double getTotalSpentForDateRange(const QDate &startDate, const QDate &endDate);
    Q_INVOKABLE void refresh();

signals:
    void dataChanged();
    void errorOccurred(const QString &error);

private:
    QList<MealRecord> m_meals;
    MealDatabase *m_database;
    void setMeals(const QList<MealRecord> &meals);
};

#endif // MEALMODEL_H 