CREATE SEQUENCE customerloginid start 1;
SELECT nextval('customerloginid');

CREATE TABLE customercart (
    cart_id character varying(32),
    customer_id integer,
    parts_id integer,
    qty double precision DEFAULT 0,
    price double precision DEFAULT 0,
    taxaccounts text
);

CREATE TABLE customerlogin (
    id integer DEFAULT nextval('customerloginid') primary key,
    "login" character varying(100) unique,
    passwd character(32),
    "session" character(32) unique,
    session_exp character varying(20),
    customer_id integer
);

CREATE TABLE partsattr (
    parts_id INTEGER,
    hotnew VARCHAR(3)
);

CREATE TABLE parts_alt (parts_id integer, alt_parts_id integer);
ALTER TABLE parts ADD pos BOOLEAN DEFAULT true;

