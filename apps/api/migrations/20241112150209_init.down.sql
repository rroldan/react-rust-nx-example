-- Add down migration script here
-- Drop tables in the reverse order of creation to maintain integrity
-- Removing OAuth2 framework tables

-- Drop the oauth_public_keys table
DROP TABLE IF EXISTS oauth_public_keys;

-- Drop the oauth_jti table
DROP TABLE IF EXISTS oauth_jti;

-- Drop the oauth_jwt table
DROP TABLE IF EXISTS oauth_jwt;

-- Drop the oauth_scopes table
DROP TABLE IF EXISTS oauth_scopes;

-- Drop the oauth_users table
DROP TABLE IF EXISTS oauth_users;

-- Drop the oauth_refresh_tokens table
DROP TABLE IF EXISTS oauth_refresh_tokens;

-- Drop the oauth_authorization_codes table
DROP TABLE IF EXISTS oauth_authorization_codes;

-- Drop the oauth_access_tokens table
DROP TABLE IF EXISTS oauth_access_tokens;

-- Drop the oauth_clients table
DROP TABLE IF EXISTS oauth_clients;

-- Drop core tables

-- Drop the user table
DROP TABLE IF EXISTS "user";

-- Drop the tag table
DROP TABLE IF EXISTS tag;

-- Drop the pet table
DROP TABLE IF EXISTS pet;

-- Drop the order table
DROP TABLE IF EXISTS "order";

-- Drop the category table
DROP TABLE IF EXISTS category;

-- Drop the api_response table
DROP TABLE IF EXISTS api_response;

-- Optional: Drop the database and role if they were created for this schema
 -- DROP DATABASE IF EXISTS "petstore";
 -- DROP USER IF EXISTS "petstore";
