Markdown# Qwaiter API - Endpoints Documentation

## Guest Endpoints (Public - QR Code Flow)

### GET /guest/table/:token
- **Description**: Guest scans QR code and retrieves table + full menu
- **Auth**: GuestGuard (auto-generates guest token if none exists)
- **Response**:
  ```json
  {
    "table": {
      "tableID": "uuid",
      "tableName": "Asztal 5",
      "authCode": "A5",
      "restaurantID": "uuid"
    },
    "restaurant": {
      "restaurantID": "uuid",
      "restaurantName": "My Restaurant"
    },
    "menu": [ array of categories with menu items ]
  }
POST /guest/order

Description: Guest places an order from the table
Auth: GuestGuard
Body (CreateOrderDto):
tableID
authCode
items: array of { menuItemID, quantity }

Response:JSON{
  "message": "Order successfully placed!",
  "orderID": "uuid",
  "totalAmount": 12500.50
}

GET /guest/my-orders

Description: Guest retrieves all their orders for the current table
Auth: GuestGuard
Query params: tableID, authCode
Response:JSON{
  "tableID": "uuid",
  "tableName": "Asztal 5",
  "orders": [
    {
      "orderID": "uuid",
      "status": "pending",
      "totalAmount": 12500.50,
      "createdAt": "2026-03-23T...",
      "items": [ array of order items with names and subtotals ]
    }
  ]
}

POST /guest/leave-table

Description: Guest leaves the table (ends their session at this table)
Auth: GuestGuard
Body (LeaveTableDto):
tableID
authCode

Response:JSON{
  "message": "Asztal sikeresen elhagyva. Viszontlátásra!",
  "tableID": "uuid",
  "tableName": "Asztal 5"
}

# Qwaiter API - Endpoint Dokumentáció

## Vendég (Guest) endpointok (QR kódos folyamat)

### GET /guest/table/:token
- **Leírás**: Vendég beolvassa a QR kódot, visszaadja az asztal adatait + teljes menüt
- **Auth**: GuestGuard (automatikusan generál guest tokent, ha nincs)
- **Visszatérési érték**:
  ```json
  {
    "table": {
      "tableID": "uuid",
      "tableName": "Asztal 5",
      "authCode": "A5",
      "restaurantID": "uuid"
    },
    "restaurant": {
      "restaurantID": "uuid",
      "restaurantName": "Éttermem"
    },
    "menu": [ kategóriák tömbje a menüpontokkal együtt ]
  }
POST /guest/order

Leírás: Vendég lead egy rendelést az asztalról
Auth: GuestGuard
Body (CreateOrderDto):
tableID
authCode
items: tömb { menuItemID, quantity } formátumban

Visszatérési érték:JSON{
  "message": "Rendelés sikeresen leadva!",
  "orderID": "uuid",
  "totalAmount": 12500.50
}

GET /guest/my-orders

Leírás: Vendég lekéri az adott asztalhoz tartozó összes eddigi rendelését
Auth: GuestGuard
Query paraméterek: tableID, authCode
Visszatérési érték:JSON{
  "tableID": "uuid",
  "tableName": "Asztal 5",
  "orders": [
    {
      "orderID": "uuid",
      "status": "pending",
      "totalAmount": 12500.50,
      "createdAt": "2026-03-23T...",
      "items": [ rendelési tételek nevekkel és részösszeggel ]
    }
  ]
}

POST /guest/leave-table

Leírás: Vendég elhagyja az asztalt (kilép a jelenlegi asztali session-ből)
Auth: GuestGuard
Body (LeaveTableDto):
tableID
authCode

Visszatérési érték:JSON{
  "message": "Asztal sikeresen elhagyva. Viszontlátásra!",
  "tableID": "uuid",
  "tableName": "Asztal 5"
}