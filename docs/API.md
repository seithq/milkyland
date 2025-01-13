## 1C

### Номенклатура ТМЦ

`POST https://qr.milkyland.kz/api/material_assets`

```json
{
  "id": 1,
  "onec_id": 111,
  "event": "create|update|destroy",
  "name": "Гофрокороб 384*290*210",
  "article": "5436666"
}
```

### Номенклатура ГП

`POST https://qr.milkyland.kz/api/products`

```json
{
  "id": 1,
  "onec_id": 111,
  "event": "create|update|destroy",
  "name": "Молоко 3.2% Фин-Пак 1 л",
  "article": "FIN1313"
}
```

### Поставщики

`POST https://qr.milkyland.kz/api/suppliers`

```json
{
  "id": 1,
  "onec_id": 111,
  "event": "create|update|destroy",
  "name": "ООО Компания Аструм",
  "bin": "123456789012",
  "contact_person": "Иванов Иван",
  "job_title": "Директор",
  "phone_number": "+77771234567",
  "email_address": "ceo@example.com",
  "entity_code": "",
  "bank_name": "",
  "bank_account": "",
  "bank_code": "",
  "foreign": "true|false",
  "identification_number": ""
}
```

### Покупатели

`POST https://qr.milkyland.kz/api/clients`

```json
{
  "id": 1,
  "onec_id": 111,
  "event": "create|update|destroy",
  "name": "ООО Компания Аструм",
  "bin": "123456789012",
  "contact_person": "Иванов Иван",
  "job_title": "Директор",
  "phone_number": "+77771234567",
  "email_address": "ceo@example.com",
  "entity_code": "",
  "bank_name": "",
  "bank_account": "",
  "bank_code": ""
}
```

### Накладная прихода

При создании накладной в системе отсылается номер накладной в 1С, который будет использоваться в дальнейшем для измененния статуса.

```json
{
  "id": 1,
  "new_storage_id": 3,
  "leftovers": [
    {
      "id": 11,
      "storage_id": 3,
      "subject_type": "MaterialAsset|Product",
      "subject_id": 22,
      "count": 100,
      "price": 100000.0
    }
  ]
}
```

#### Подтверждение 1С

`PUT|PATCH https://qr.milkyland.kz/api/waybills/:id`

```json
{
  "approved_at": "2024-12-01 17:24:20",
  "onec_id": 1
}
```

### Накладная списания

```json
{
  "id": 1,
  "storage_id": 2,
  "sender_id": 4,
  "leftovers": [
    {
      "id": 11,
      "storage_id": 2,
      "subject_type": "MaterialAsset|Product",
      "subject_id": 22,
      "count": 100,
      "price": 0.0
    }
  ]
}
```

### Накладная перемещения

```json
{
  "id": 1,
  "storage_id": 2,
  "new_storage_id": 3,
  "sender_id": 4,
  "receiver_id": 5,
  "leftovers": [
    {
      "id": 11,
      "storage_id": 2,
      "subject_type": "MaterialAsset|Product",
      "subject_id": 22,
      "count": -100,
      "price": 0.0
    },
    {
      "id": 12,
      "storage_id": 3,
      "subject_type": "MaterialAsset|Product",
      "subject_id": 22,
      "count": 100,
      "price": 0.0
    }
  ]
}
```

### Накладная расхода

```json
{
  "id": 1,
  "storage_id": 2,
  "sender_id": 4,
  "route_sheet": {
    "shipment": {
      "region": {
        "id": 4,
        "code": "04",
        "name": "Актобе"
      },
      "client": {
        "id": 5,
        "onec_id": 55,
        "name": "",
        "bin": ""
      }
    },
    "vehicle_plate_number": "",
    "driver_name": "",
    "driver_phone_number": ""
  },
  "leftovers": [
    {
      "id": 11,
      "storage_id": 2,
      "subject_type": "MaterialAsset|Product",
      "subject_id": 22,
      "count": -100,
      "price": 0.0
    }
  ]
}
```

### Финансы - Поступления

`POST https://qr.milkyland.kz/api/transactions`

```json
{
  "kind": "income",
  "onec_id": 11,
  "bank_account_id": 2,
  "article_id": 3,
  "contragent_type": "Client",
  "contragent_id": 4,
  "amount": 100000.0
}
```

### Финансы - Расходы

Бухгалтер в Системе жмет кнопку "Подтвердить оплату в банке", Система отправляет в 1С непроведенный расход денег.

```json
{
  "id": 1,
  "kind": "expense",
  "created_at": "2024-12-01 17:24:20",
  "bank_account_id": 2,
  "article_id": 3,
  "contragent_type": "Supplier",
  "contragent_id": 4,
  "amount": 10000.0
}
```

#### Изменения статуса - Оплачено в 1С

`POST https://qr.milkyland.kz/api/transactions/:id`

```json
{
  "executed_at": "2024-12-01 17:24:20",
  "completed": "true|false"
}
```

### Справочник счетов

`GET https://qr.milkyland.kz/api/bank_accounts`

```json
[
  {
    "id": 1,
    "company_id": 1,
    "name": "Главный счет",
    "number": "KZ1234567890",
    "main": "true|false"
  }
]
```

### Справочник статьей

`GET https://qr.milkyland.kz/api/articles`

```json
[
  {
    "id": 1,
    "financial_category_id": 2,
    "activity_type_id": 3,
    "name": "Производственные затраты",
    "kind": "expense"
  }
]
```