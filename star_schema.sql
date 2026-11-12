-- Star schema for the Enterprise BI Suite (ANSI SQL; executed by etl/build_warehouse.py on SQLite
-- and portable to SQL Server with minor type changes: TEXT->NVARCHAR, REAL->DECIMAL(19,4)).
-- Dimension keys reuse the stable AdventureWorks business IDs; -1 = "Unknown / none" member.

DROP TABLE IF EXISTS DimDate;
CREATE TABLE DimDate (
  DateKey INTEGER PRIMARY KEY, Date TEXT NOT NULL, Year INTEGER, Quarter INTEGER, QuarterLabel TEXT,
  MonthNumber INTEGER, MonthName TEXT, YearMonth INTEGER, YearMonthLabel TEXT, DayOfMonth INTEGER,
  DayOfWeekNumber INTEGER, DayName TEXT, IsWeekend INTEGER);

DROP TABLE IF EXISTS DimProduct;
CREATE TABLE DimProduct (
  ProductKey INTEGER PRIMARY KEY, ProductName TEXT, ProductNumber TEXT, Category TEXT, Subcategory TEXT,
  Color TEXT, Size TEXT, ProductLine TEXT, Class TEXT, MakeFlag INTEGER, StandardCost REAL, ListPrice REAL);

DROP TABLE IF EXISTS DimCustomer;
CREATE TABLE DimCustomer (
  CustomerKey INTEGER PRIMARY KEY, CustomerType TEXT, CustomerName TEXT, TerritoryKey INTEGER);

DROP TABLE IF EXISTS DimTerritory;
CREATE TABLE DimTerritory (
  TerritoryKey INTEGER PRIMARY KEY, Region TEXT, Country TEXT, RegionGroup TEXT);

DROP TABLE IF EXISTS DimSalesPerson;
CREATE TABLE DimSalesPerson (
  SalesPersonKey INTEGER PRIMARY KEY, SalesPersonName TEXT, TerritoryKey INTEGER, SalesQuota REAL);

DROP TABLE IF EXISTS DimVendor;
CREATE TABLE DimVendor (
  VendorKey INTEGER PRIMARY KEY, VendorName TEXT, CreditRating INTEGER, PreferredVendor INTEGER, ActiveVendor INTEGER);

DROP TABLE IF EXISTS DimEmployee;
CREATE TABLE DimEmployee (
  EmployeeKey INTEGER PRIMARY KEY, EmployeeName TEXT, JobTitle TEXT, Gender TEXT, MaritalStatus TEXT,
  HireDate TEXT, HireDateKey INTEGER, AgeBand TEXT, SalariedFlag INTEGER, VacationHours INTEGER, SickLeaveHours INTEGER,
  IsCurrent INTEGER, Department TEXT, DepartmentGroup TEXT, CurrentHourlyRate REAL, TenureYears REAL);

DROP TABLE IF EXISTS FactSales;
CREATE TABLE FactSales (
  SalesOrderID INTEGER, SalesOrderDetailID INTEGER, OrderDateKey INTEGER, ShipDateKey INTEGER,
  ProductKey INTEGER, CustomerKey INTEGER, TerritoryKey INTEGER, SalesPersonKey INTEGER, Channel TEXT,
  OrderQty INTEGER, UnitPrice REAL, UnitPriceDiscount REAL, GrossSales REAL, DiscountAmount REAL,
  NetSales REAL, TotalCost REAL, GrossProfit REAL, PRIMARY KEY (SalesOrderID, SalesOrderDetailID));

DROP TABLE IF EXISTS FactPurchasing;
CREATE TABLE FactPurchasing (
  PurchaseOrderID INTEGER, PurchaseOrderDetailID INTEGER, OrderDateKey INTEGER, ShipDateKey INTEGER, DueDateKey INTEGER,
  VendorKey INTEGER, ProductKey INTEGER, BuyerKey INTEGER, OrderStatus TEXT, OrderQty INTEGER, ReceivedQty REAL,
  RejectedQty REAL, StockedQty REAL, UnitPrice REAL, LineTotal REAL, LateFlag INTEGER,
  PRIMARY KEY (PurchaseOrderID, PurchaseOrderDetailID));

DROP TABLE IF EXISTS FactProduction;
CREATE TABLE FactProduction (
  WorkOrderID INTEGER PRIMARY KEY, ProductKey INTEGER, StartDateKey INTEGER, EndDateKey INTEGER, DueDateKey INTEGER,
  OrderQty INTEGER, StockedQty INTEGER, ScrappedQty INTEGER, DaysLate INTEGER, LateFlag INTEGER);

DROP TABLE IF EXISTS FactEmployeePay;
CREATE TABLE FactEmployeePay (
  EmployeeKey INTEGER, RateChangeDateKey INTEGER, HourlyRate REAL, PayFrequency INTEGER,
  PRIMARY KEY (EmployeeKey, RateChangeDateKey));

DROP TABLE IF EXISTS SecurityMap;
CREATE TABLE SecurityMap (UserEmail TEXT, TerritoryKey INTEGER, RegionManager TEXT, PRIMARY KEY (UserEmail, TerritoryKey));
