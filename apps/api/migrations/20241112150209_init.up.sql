-- Add up migration script here


-- Create the role for the database
--CREATE USER "petstore" WITH LOGIN SUPERUSER PASSWORD 'petstore';

-- Create the database
-- CREATE DATABASE "petstore" WITH OWNER = "petstore";


-- --------------------------------------------------------
-- Table structure for `api_response`

CREATE TABLE IF NOT EXISTS api_response (
  code INTEGER,
  type TEXT,
  message TEXT
);

COMMENT ON TABLE api_response IS 'Describes the result of uploading an image resource. Original model name - ApiResponse.';

-- --------------------------------------------------------
-- Table structure for `category`

CREATE TABLE IF NOT EXISTS category (
  id BIGINT,
  name TEXT
);

COMMENT ON TABLE category IS 'A category for a pet. Original model name - Category.';

-- --------------------------------------------------------
-- Table structure for `order`

CREATE TABLE IF NOT EXISTS "order" (
  id BIGINT,
  pet_id BIGINT,
  quantity INTEGER,
  ship_date TIMESTAMP,
  status TEXT CHECK (status IN ('placed', 'approved', 'delivered')),
  complete BOOLEAN DEFAULT false
);

COMMENT ON TABLE "order" IS 'An order for a pet from the pet store. Original model name - Order.';
COMMENT ON COLUMN "order".pet_id IS 'Original param name - petId.';
COMMENT ON COLUMN "order".ship_date IS 'Original param name - shipDate.';
COMMENT ON COLUMN "order".status IS 'Order Status';

-- --------------------------------------------------------
-- Table structure for `pet`

CREATE TABLE IF NOT EXISTS pet (
  id BIGINT,
  category TEXT,
  name TEXT NOT NULL,
  photo_urls JSONB NOT NULL,
  tags JSONB,
  status TEXT CHECK (status IN ('available', 'pending', 'sold'))
);

COMMENT ON TABLE pet IS 'A pet for sale in the pet store. Original model name - Pet.';
COMMENT ON COLUMN pet.photo_urls IS 'Original param name - photoUrls.';
COMMENT ON COLUMN pet.status IS 'pet status in the store';

-- --------------------------------------------------------
-- Table structure for `tag`

CREATE TABLE IF NOT EXISTS tag (
  id BIGINT,
  name TEXT
);

COMMENT ON TABLE tag IS 'A tag for a pet. Original model name - Tag.';

-- --------------------------------------------------------
-- Table structure for `user`

CREATE TABLE IF NOT EXISTS "user" (
  id BIGINT,
  username TEXT,
  first_name TEXT,
  last_name TEXT,
  email TEXT,
  password TEXT,
  phone TEXT,
  user_status INTEGER
);

COMMENT ON TABLE "user" IS 'A User who is purchasing from the pet store. Original model name - User.';
COMMENT ON COLUMN "user".first_name IS 'Original param name - firstName.';
COMMENT ON COLUMN "user".last_name IS 'Original param name - lastName.';
COMMENT ON COLUMN "user".user_status IS 'User Status. Original param name - userStatus.';

-- --------------------------------------------------------
-- OAuth2 framework tables

-- Table structure for `oauth_clients`

CREATE TABLE IF NOT EXISTS oauth_clients (
  client_id VARCHAR(80) PRIMARY KEY,
  client_secret VARCHAR(80),
  redirect_uri VARCHAR(2000),
  grant_types VARCHAR(80),
  scope VARCHAR(4000),
  user_id VARCHAR(80)
);

-- Table structure for `oauth_access_tokens`

CREATE TABLE IF NOT EXISTS oauth_access_tokens (
  access_token VARCHAR(40) PRIMARY KEY,
  client_id VARCHAR(80),
  user_id VARCHAR(80),
  expires TIMESTAMPTZ NOT NULL,
  scope VARCHAR(4000)
);

-- Table structure for `oauth_authorization_codes`

CREATE TABLE IF NOT EXISTS oauth_authorization_codes (
  authorization_code VARCHAR(40) PRIMARY KEY,
  client_id VARCHAR(80),
  user_id VARCHAR(80),
  redirect_uri VARCHAR(2000) NOT NULL,
  expires TIMESTAMPTZ NOT NULL,
  scope VARCHAR(4000),
  id_token VARCHAR(1000)
);

-- Table structure for `oauth_refresh_tokens`

CREATE TABLE IF NOT EXISTS oauth_refresh_tokens (
  refresh_token VARCHAR(40) PRIMARY KEY,
  client_id VARCHAR(80),
  user_id VARCHAR(80),
  expires TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
  scope VARCHAR(4000)
);

-- Table structure for `oauth_users`

CREATE TABLE IF NOT EXISTS oauth_users (
  username VARCHAR(80),
  password VARCHAR(255),
  first_name VARCHAR(80),
  last_name VARCHAR(80),
  email VARCHAR(2000),
  email_verified BOOLEAN,
  scope VARCHAR(4000)
);

-- Table structure for `oauth_scopes`

CREATE TABLE IF NOT EXISTS oauth_scopes (
  scope VARCHAR(80) PRIMARY KEY,
  is_default BOOLEAN
);

-- Table structure for `oauth_jwt`

CREATE TABLE IF NOT EXISTS oauth_jwt (
  client_id VARCHAR(80) PRIMARY KEY,
  subject VARCHAR(80),
  public_key VARCHAR(2000) NOT NULL
);

-- Table structure for `oauth_jti`

CREATE TABLE IF NOT EXISTS oauth_jti (
  issuer VARCHAR(80) PRIMARY KEY,
  subject VARCHAR(80),
  audience VARCHAR(80),
  expires TIMESTAMPTZ NOT NULL,
  jti VARCHAR(2000) NOT NULL
);

-- Table structure for `oauth_public_keys`

CREATE TABLE IF NOT EXISTS oauth_public_keys (
  client_id VARCHAR(80),
  public_key VARCHAR(2000),
  private_key VARCHAR(2000),
  encryption_algorithm VARCHAR(100) DEFAULT 'RS256'
);

