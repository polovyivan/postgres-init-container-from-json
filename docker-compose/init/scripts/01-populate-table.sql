DROP TABLE IF EXISTS customer;
DROP TABLE IF EXISTS customer_from_file;

CREATE TABLE customer
(
    id            VARCHAR(36) PRIMARY KEY,
    full_name     VARCHAR(200) NOT NULL,
    phone_number  VARCHAR(20)  NOT NULL,
    address       JSON         NOT NULL,
    payment_types TEXT[]       NOT NULL,
    is_active     BOOLEAN      NOT NULL,
    created_at    DATE         NOT NULL
);


CREATE TABLE customer_from_file
(
    id            VARCHAR(36) PRIMARY KEY,
    full_name     VARCHAR(200) NOT NULL,
    phone_number  VARCHAR(20)  NOT NULL,
    address       JSON         NOT NULL,
    payment_types TEXT[]       NOT NULL,
    is_active     BOOLEAN      NOT NULL,
    created_at    DATE         NOT NULL
);

----------------------------------------------
          ---- From statement ----
----------------------------------------------

with customer_json (doc) as (values ('[
  {
    "id": 0,
    "full_name": "Ronald Koepp",
    "phone_number": "324-910-3627",
    "address": {
      "number": "4225",
      "street": "Joesph Highway",
      "city": "North Jenifferside",
      "state": "ME",
      "zipCode": "47362"
    },
    "payment_types": [
      "VISA",
      "AMEX"
    ],
    "is_active": true,
    "created_at": "2017-05-03"
  },
  {
    "id": 1,
    "full_name": "Luanne Buckridge",
    "phone_number": "583-980-5792",
    "address": {
      "number": "656",
      "street": "Moore Drive",
      "city": "West Sanjuanitafurt",
      "state": "VT",
      "zipCode": "50471"
    },
    "payment_types": [
      "MASTER",
      "DISCOVER"
    ],
    "is_active": false,
    "created_at": "2013-08-14"
  }
]'::jsonb))
insert
into customer
    (id, full_name, phone_number, address, payment_types, is_active, created_at)
select c.*
from customer_json
         cross join lateral jsonb_populate_recordset(null::customer, doc) as c;

select * from customer;

----------------------------------------------
            ---- From file ----
----------------------------------------------

\set content `cat /tmp/data/customers.json`
create temp table customer_from_file_json ( j jsonb );
insert into customer_from_file_json values (:'content');
select * from customer_from_file_json;

insert
into customer_from_file
select cf.*
from customer_from_file_json
         cross join lateral jsonb_populate_recordset(null::customer_from_file, j) as cf;

select * from customer_from_file;


