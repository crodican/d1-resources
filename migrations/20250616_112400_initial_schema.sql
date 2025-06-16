-- migrations/20250616_112400_initial_schema.sql

-- This migration sets up the initial schema for the resources database.
-- It includes lookup tables, the main resources table, and junction tables
-- for many-to-many relationships for faceted filtering.

-- Enable foreign key constraints
-- This is crucial for D1 to enforce referential integrity.
-- It's often good practice to include this in migration files,
-- though D1 generally enables them by default.
PRAGMA foreign_keys = ON;

-- 1. Create Lookup Tables (for Facet Options)

-- Counties Lookup Table
CREATE TABLE IF NOT EXISTS Counties (
    county_id INTEGER PRIMARY KEY,
    county_name TEXT NOT NULL UNIQUE
);

-- ResourceTypes Lookup Table
CREATE TABLE IF NOT EXISTS ResourceTypes (
    resource_type_id INTEGER PRIMARY KEY,
    type_name TEXT NOT NULL UNIQUE
);

-- Categories Lookup Table
CREATE TABLE IF NOT EXISTS Categories (
    category_id INTEGER PRIMARY KEY,
    category_name TEXT NOT NULL UNIQUE
);

-- PopulationsServed Lookup Table
CREATE TABLE IF NOT EXISTS PopulationsServed (
    population_id INTEGER PRIMARY KEY,
    population_name TEXT NOT NULL UNIQUE
);

-- 2. Create the Main 'resources' Table
CREATE TABLE IF NOT EXISTS resources (
    id INTEGER PRIMARY KEY,
    location_name TEXT,
    organization TEXT,
    more_info TEXT,
    phone TEXT,
    address TEXT,
    city TEXT,
    state TEXT,
    zip_code TEXT,
    website TEXT,
    image TEXT,
    latitude REAL,
    longitude REAL,
    phone_url TEXT,
    full_address TEXT,
    navigation_url TEXT
);

-- 3. Create Junction Tables (for Many-to-Many Relationships)

-- Junction table for Resources and Counties
CREATE TABLE IF NOT EXISTS resource_counties (
    resource_id INTEGER,
    county_id INTEGER,
    PRIMARY KEY (resource_id, county_id),
    FOREIGN KEY (resource_id) REFERENCES resources(id) ON DELETE CASCADE,
    FOREIGN KEY (county_id) REFERENCES Counties(county_id) ON DELETE CASCADE
);

-- Junction table for Resources and Resource Types
CREATE TABLE IF NOT EXISTS resource_resource_types (
    resource_id INTEGER,
    resource_type_id INTEGER,
    PRIMARY KEY (resource_id, resource_type_id),
    FOREIGN KEY (resource_id) REFERENCES resources(id) ON DELETE CASCADE,
    FOREIGN KEY (resource_type_id) REFERENCES ResourceTypes(resource_type_id) ON DELETE CASCADE
);

-- Junction table for Resources and Categories
CREATE TABLE IF NOT EXISTS resource_categories (
    resource_id INTEGER,
    category_id INTEGER,
    PRIMARY KEY (resource_id, category_id),
    FOREIGN KEY (resource_id) REFERENCES resources(id) ON DELETE CASCADE,
    FOREIGN KEY (category_id) REFERENCES Categories(category_id) ON DELETE CASCADE
);

-- Junction table for Resources and Populations Served
CREATE TABLE IF NOT EXISTS resource_populations_served (
    resource_id INTEGER,
    population_id INTEGER,
    PRIMARY KEY (resource_id, population_id),
    FOREIGN KEY (resource_id) REFERENCES resources(id) ON DELETE CASCADE,
    FOREIGN KEY (population_id) REFERENCES PopulationsServed(population_id) ON DELETE CASCADE
);