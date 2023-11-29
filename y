{
  "indexes": [
    {
      "collectionGroup": "absences",
      "queryScope": "COLLECTION",
      "fields": [
        {
          "fieldPath": "company_id",
          "order": "ASCENDING"
        },
        {
          "fieldPath": "employee.employee_id",
          "order": "ASCENDING"
        },
        {
          "fieldPath": "employee_read",
          "order": "ASCENDING"
        },
        {
          "fieldPath": "date",
          "order": "DESCENDING"
        }
      ]
    },
    {
      "collectionGroup": "absences",
      "queryScope": "COLLECTION",
      "fields": [
        {
          "fieldPath": "company_id",
          "order": "ASCENDING"
        },
        {
          "fieldPath": "employee.employee_id",
          "order": "ASCENDING"
        },
        {
          "fieldPath": "status",
          "order": "ASCENDING"
        }
      ]
    },
    {
      "collectionGroup": "absences",
      "queryScope": "COLLECTION",
      "fields": [
        {
          "fieldPath": "company_id",
          "order": "ASCENDING"
        },
        {
          "fieldPath": "status",
          "order": "ASCENDING"
        }
      ]
    },
    {
      "collectionGroup": "absences",
      "queryScope": "COLLECTION",
      "fields": [
        {
          "fieldPath": "company_id",
          "order": "ASCENDING"
        },
        {
          "fieldPath": "status",
          "order": "ASCENDING"
        },
        {
          "fieldPath": "date",
          "order": "DESCENDING"
        }
      ]
    },
    {
      "collectionGroup": "absences",
      "queryScope": "COLLECTION",
      "fields": [
        {
          "fieldPath": "date",
          "order": "DESCENDING"
        },
        {
          "fieldPath": "company_id",
          "order": "DESCENDING"
        }
      ]
    },
    {
      "collectionGroup": "absences",
      "queryScope": "COLLECTION",
      "fields": [
        {
          "fieldPath": "date",
          "order": "DESCENDING"
        },
        {
          "fieldPath": "status",
          "order": "DESCENDING"
        }
      ]
    },
    {
      "collectionGroup": "absences",
      "queryScope": "COLLECTION",
      "fields": [
        {
          "fieldPath": "status",
          "order": "ASCENDING"
        },
        {
          "fieldPath": "date",
          "order": "DESCENDING"
        }
      ]
    },
    {
      "collectionGroup": "justifications",
      "queryScope": "COLLECTION",
      "fields": [
        {
          "fieldPath": "absence.employee.employee_id",
          "order": "ASCENDING"
        },
        {
          "fieldPath": "company_id",
          "order": "ASCENDING"
        },
        {
          "fieldPath": "date",
          "order": "DESCENDING"
        }
      ]
    },
    {
      "collectionGroup": "justifications",
      "queryScope": "COLLECTION",
      "fields": [
        {
          "fieldPath": "absence.employee.employee_id",
          "order": "ASCENDING"
        },
        {
          "fieldPath": "company_id",
          "order": "ASCENDING"
        },
        {
          "fieldPath": "employee_read",
          "order": "ASCENDING"
        },
        {
          "fieldPath": "status",
          "order": "ASCENDING"
        }
      ]
    },
    {
      "collectionGroup": "justifications",
      "queryScope": "COLLECTION",
      "fields": [
        {
          "fieldPath": "company_id",
          "order": "ASCENDING"
        },
        {
          "fieldPath": "date",
          "order": "DESCENDING"
        }
      ]
    },
    {
      "collectionGroup": "justifications",
      "queryScope": "COLLECTION",
      "fields": [
        {
          "fieldPath": "company_id",
          "order": "ASCENDING"
        },
        {
          "fieldPath": "employee_read",
          "order": "ASCENDING"
        },
        {
          "fieldPath": "status",
          "order": "ASCENDING"
        }
      ]
    },
    {
      "collectionGroup": "justifications",
      "queryScope": "COLLECTION",
      "fields": [
        {
          "fieldPath": "company_id",
          "order": "ASCENDING"
        },
        {
          "fieldPath": "user_read",
          "order": "ASCENDING"
        },
        {
          "fieldPath": "status",
          "order": "ASCENDING"
        }
      ]
    },
    {
      "collectionGroup": "timelines",
      "queryScope": "COLLECTION",
      "fields": [
        {
          "fieldPath": "company_id",
          "order": "ASCENDING"
        },
        {
          "fieldPath": "date",
          "order": "DESCENDING"
        }
      ]
    },
    {
      "collectionGroup": "timelines",
      "queryScope": "COLLECTION",
      "fields": [
        {
          "fieldPath": "company_id",
          "order": "ASCENDING"
        },
        {
          "fieldPath": "employee_id",
          "order": "ASCENDING"
        },
        {
          "fieldPath": "date",
          "order": "ASCENDING"
        }
      ]
    },
    {
      "collectionGroup": "timelines",
      "queryScope": "COLLECTION",
      "fields": [
        {
          "fieldPath": "company_id",
          "order": "ASCENDING"
        },
        {
          "fieldPath": "employee_id",
          "order": "ASCENDING"
        },
        {
          "fieldPath": "date",
          "order": "DESCENDING"
        }
      ]
    },
    {
      "collectionGroup": "timelines",
      "queryScope": "COLLECTION",
      "fields": [
        {
          "fieldPath": "company_id",
          "order": "ASCENDING"
        },
        {
          "fieldPath": "employee_id",
          "order": "ASCENDING"
        },
        {
          "fieldPath": "date_checkin",
          "order": "DESCENDING"
        }
      ]
    },
    {
      "collectionGroup": "timelines",
      "queryScope": "COLLECTION",
      "fields": [
        {
          "fieldPath": "company_id",
          "order": "ASCENDING"
        },
        {
          "fieldPath": "employee_id",
          "order": "ASCENDING"
        },
        {
          "fieldPath": "title",
          "order": "ASCENDING"
        },
        {
          "fieldPath": "date_checkin",
          "order": "DESCENDING"
        }
      ]
    },
    {
      "collectionGroup": "timelines",
      "queryScope": "COLLECTION",
      "fields": [
        {
          "fieldPath": "employee_id",
          "order": "ASCENDING"
        },
        {
          "fieldPath": "date",
          "order": "DESCENDING"
        }
      ]
    }
  ],
  "fieldOverrides": []
}
