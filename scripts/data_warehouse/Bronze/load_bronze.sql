/*
===============================================================================
BRONZE LAYER - DATA LOAD SCRIPT
===============================================================================
Purpose:
    Load raw source data from CSV files into Bronze tables.

Notes:
    - Existing data is removed before each load.
    - Data is loaded exactly as received from source files.
    - No cleansing or validation is performed in Bronze.
    - Data quality checks are handled in the Silver layer.

Execution:
    Run after the Bronze DDL script has been executed.

===============================================================================
*/

BEGIN TRY

    PRINT '=====================================================';
    PRINT 'Starting Bronze Layer Data Load';
    PRINT '=====================================================';

    -- ============================================================
    -- LOAD: ORDER DETAILS
    -- ============================================================

    PRINT 'Loading bronze.order_details...';

    TRUNCATE TABLE bronze.order_details;

    BULK INSERT bronze.order_details
    FROM 'D:\DOCUMENTS\Education\SQL\pizza project\datasets\order_details.csv'
    WITH (
        FIRSTROW = 2,
        FIELDTERMINATOR = ',',
        ROWTERMINATOR = '\n',
        TABLOCK
    );

    PRINT 'bronze.order_details loaded successfully.';


    -- ============================================================
    -- LOAD: ORDERS
    -- ============================================================

    PRINT 'Loading bronze.orders...';

    TRUNCATE TABLE bronze.orders;

    BULK INSERT bronze.orders
    FROM 'D:\DOCUMENTS\Education\SQL\pizza project\datasets\orders.csv'
    WITH (
        FIRSTROW = 2,
        FIELDTERMINATOR = ',',
        ROWTERMINATOR = '\n',
        TABLOCK
    );

    PRINT 'bronze.orders loaded successfully.';


    -- ============================================================
    -- LOAD: PIZZA TYPES
    -- ============================================================

    PRINT 'Loading bronze.pizza_types...';

    TRUNCATE TABLE bronze.pizza_types;

    BULK INSERT bronze.pizza_types
    FROM 'D:\DOCUMENTS\Education\SQL\pizza project\datasets\pizza_types.csv'
    WITH (
        FIRSTROW = 2,
        FIELDTERMINATOR = ',',
        ROWTERMINATOR = '\n',
        TABLOCK
    );

    PRINT 'bronze.pizza_types loaded successfully.';


    -- ============================================================
    -- LOAD: PIZZAS
    -- ============================================================

    PRINT 'Loading bronze.pizzas...';

    TRUNCATE TABLE bronze.pizzas;

    BULK INSERT bronze.pizzas
    FROM 'D:\DOCUMENTS\Education\SQL\pizza project\datasets\pizzas.csv'
    WITH (
        FIRSTROW = 2,
        FIELDTERMINATOR = ',',
        ROWTERMINATOR = '\n',
        TABLOCK
    );

    PRINT 'bronze.pizzas loaded successfully.';

    PRINT '=====================================================';
    PRINT 'Bronze Layer Data Load Completed Successfully';
    PRINT '=====================================================';

END TRY

BEGIN CATCH

    PRINT '=====================================================';
    PRINT 'ERROR DURING BRONZE DATA LOAD';
    PRINT '=====================================================';

    PRINT 'Error Number  : ' + CAST(ERROR_NUMBER() AS VARCHAR(20));
    PRINT 'Error Message : ' + ERROR_MESSAGE();
    PRINT 'Error Line    : ' + CAST(ERROR_LINE() AS VARCHAR(20));

    THROW;

END CATCH;
GO