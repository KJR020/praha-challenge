-- DROP SCHEMA public;

CREATE SCHEMA public AUTHORIZATION pg_database_owner;

-- DROP TYPE public.claim_reason_enum;

CREATE TYPE public.claim_reason_enum AS ENUM (
	'missing_item',
	'wrong_item',
	'production_failure',
	'other');

-- DROP TYPE public.order_claim_type_enum;

CREATE TYPE public.order_claim_type_enum AS ENUM (
	'refund',
	'replace');

-- DROP TYPE public.order_status_enum;

CREATE TYPE public.order_status_enum AS ENUM (
	'pending',
	'completed',
	'draft',
	'archived',
	'canceled',
	'requires_action');

-- DROP TYPE public.return_status_enum;

CREATE TYPE public.return_status_enum AS ENUM (
	'open',
	'requested',
	'received',
	'partially_received',
	'canceled');

-- DROP SEQUENCE public.link_module_migrations_id_seq;

CREATE SEQUENCE public.link_module_migrations_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START 1
	CACHE 1
	NO CYCLE;
-- DROP SEQUENCE public.mikro_orm_migrations_id_seq;

CREATE SEQUENCE public.mikro_orm_migrations_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START 1
	CACHE 1
	NO CYCLE;
-- DROP SEQUENCE public.order_change_action_ordering_seq;

CREATE SEQUENCE public.order_change_action_ordering_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 9223372036854775807
	START 1
	CACHE 1
	NO CYCLE;
-- DROP SEQUENCE public.order_claim_display_id_seq;

CREATE SEQUENCE public.order_claim_display_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START 1
	CACHE 1
	NO CYCLE;
-- DROP SEQUENCE public.order_display_id_seq;

CREATE SEQUENCE public.order_display_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START 1
	CACHE 1
	NO CYCLE;
-- DROP SEQUENCE public.order_exchange_display_id_seq;

CREATE SEQUENCE public.order_exchange_display_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START 1
	CACHE 1
	NO CYCLE;
-- DROP SEQUENCE public.return_display_id_seq;

CREATE SEQUENCE public.return_display_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START 1
	CACHE 1
	NO CYCLE;-- public.api_key definition

-- Drop table

-- DROP TABLE public.api_key;

CREATE TABLE public.api_key (
	id text NOT NULL,
	"token" text NOT NULL,
	salt text NOT NULL,
	redacted text NOT NULL,
	title text NOT NULL,
	"type" text NOT NULL,
	last_used_at timestamptz NULL,
	created_by text NOT NULL,
	created_at timestamptz DEFAULT now() NOT NULL,
	revoked_by text NULL,
	revoked_at timestamptz NULL,
	updated_at timestamptz DEFAULT now() NOT NULL,
	deleted_at timestamptz NULL,
	CONSTRAINT api_key_pkey PRIMARY KEY (id),
	CONSTRAINT api_key_type_check CHECK ((type = ANY (ARRAY['publishable'::text, 'secret'::text])))
);
CREATE INDEX "IDX_api_key_deleted_at" ON public.api_key USING btree (deleted_at) WHERE (deleted_at IS NULL);
CREATE UNIQUE INDEX "IDX_api_key_token_unique" ON public.api_key USING btree (token);
CREATE INDEX "IDX_api_key_type" ON public.api_key USING btree (type);


-- public.auth_identity definition

-- Drop table

-- DROP TABLE public.auth_identity;

CREATE TABLE public.auth_identity (
	id text NOT NULL,
	app_metadata jsonb NULL,
	created_at timestamptz DEFAULT now() NOT NULL,
	updated_at timestamptz DEFAULT now() NOT NULL,
	deleted_at timestamptz NULL,
	CONSTRAINT auth_identity_pkey PRIMARY KEY (id)
);
CREATE INDEX "IDX_auth_identity_deleted_at" ON public.auth_identity USING btree (deleted_at) WHERE (deleted_at IS NULL);


-- public.cart_address definition

-- Drop table

-- DROP TABLE public.cart_address;

CREATE TABLE public.cart_address (
	id text NOT NULL,
	customer_id text NULL,
	company text NULL,
	first_name text NULL,
	last_name text NULL,
	address_1 text NULL,
	address_2 text NULL,
	city text NULL,
	country_code text NULL,
	province text NULL,
	postal_code text NULL,
	phone text NULL,
	metadata jsonb NULL,
	created_at timestamptz DEFAULT now() NOT NULL,
	updated_at timestamptz DEFAULT now() NOT NULL,
	deleted_at timestamptz NULL,
	CONSTRAINT cart_address_pkey PRIMARY KEY (id)
);
CREATE INDEX "IDX_cart_address_deleted_at" ON public.cart_address USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


-- public.cart_payment_collection definition

-- Drop table

-- DROP TABLE public.cart_payment_collection;

CREATE TABLE public.cart_payment_collection (
	cart_id varchar(255) NOT NULL,
	payment_collection_id varchar(255) NOT NULL,
	id varchar(255) NOT NULL,
	created_at timestamptz(0) DEFAULT CURRENT_TIMESTAMP NOT NULL,
	updated_at timestamptz(0) DEFAULT CURRENT_TIMESTAMP NOT NULL,
	deleted_at timestamptz(0) NULL,
	CONSTRAINT cart_payment_collection_pkey PRIMARY KEY (cart_id, payment_collection_id)
);
CREATE INDEX "IDX_cart_id_-4a39f6c9" ON public.cart_payment_collection USING btree (cart_id);
CREATE INDEX "IDX_deleted_at_-4a39f6c9" ON public.cart_payment_collection USING btree (deleted_at);
CREATE INDEX "IDX_id_-4a39f6c9" ON public.cart_payment_collection USING btree (id);
CREATE INDEX "IDX_payment_collection_id_-4a39f6c9" ON public.cart_payment_collection USING btree (payment_collection_id);


-- public.cart_promotion definition

-- Drop table

-- DROP TABLE public.cart_promotion;

CREATE TABLE public.cart_promotion (
	cart_id varchar(255) NOT NULL,
	promotion_id varchar(255) NOT NULL,
	id varchar(255) NOT NULL,
	created_at timestamptz(0) DEFAULT CURRENT_TIMESTAMP NOT NULL,
	updated_at timestamptz(0) DEFAULT CURRENT_TIMESTAMP NOT NULL,
	deleted_at timestamptz(0) NULL,
	CONSTRAINT cart_promotion_pkey PRIMARY KEY (cart_id, promotion_id)
);
CREATE INDEX "IDX_cart_id_-a9d4a70b" ON public.cart_promotion USING btree (cart_id);
CREATE INDEX "IDX_deleted_at_-a9d4a70b" ON public.cart_promotion USING btree (deleted_at);
CREATE INDEX "IDX_id_-a9d4a70b" ON public.cart_promotion USING btree (id);
CREATE INDEX "IDX_promotion_id_-a9d4a70b" ON public.cart_promotion USING btree (promotion_id);


-- public.currency definition

-- Drop table

-- DROP TABLE public.currency;

CREATE TABLE public.currency (
	code text NOT NULL,
	symbol text NOT NULL,
	symbol_native text NOT NULL,
	decimal_digits int4 DEFAULT 0 NOT NULL,
	rounding numeric DEFAULT 0 NOT NULL,
	raw_rounding jsonb NOT NULL,
	"name" text NOT NULL,
	created_at timestamptz DEFAULT now() NOT NULL,
	updated_at timestamptz DEFAULT now() NOT NULL,
	deleted_at timestamptz NULL,
	CONSTRAINT currency_pkey PRIMARY KEY (code)
);


-- public.customer definition

-- Drop table

-- DROP TABLE public.customer;

CREATE TABLE public.customer (
	id text NOT NULL,
	company_name text NULL,
	first_name text NULL,
	last_name text NULL,
	email text NULL,
	phone text NULL,
	has_account bool DEFAULT false NOT NULL,
	metadata jsonb NULL,
	created_at timestamptz DEFAULT now() NOT NULL,
	updated_at timestamptz DEFAULT now() NOT NULL,
	deleted_at timestamptz NULL,
	created_by text NULL,
	CONSTRAINT customer_pkey PRIMARY KEY (id)
);
CREATE INDEX "IDX_customer_deleted_at" ON public.customer USING btree (deleted_at) WHERE (deleted_at IS NULL);
CREATE UNIQUE INDEX "IDX_customer_email_has_account_unique" ON public.customer USING btree (email, has_account) WHERE (deleted_at IS NULL);


-- public.customer_group definition

-- Drop table

-- DROP TABLE public.customer_group;

CREATE TABLE public.customer_group (
	id text NOT NULL,
	"name" text NOT NULL,
	metadata jsonb NULL,
	created_by text NULL,
	created_at timestamptz DEFAULT now() NOT NULL,
	updated_at timestamptz DEFAULT now() NOT NULL,
	deleted_at timestamptz NULL,
	CONSTRAINT customer_group_pkey PRIMARY KEY (id)
);
CREATE INDEX "IDX_customer_group_deleted_at" ON public.customer_group USING btree (deleted_at) WHERE (deleted_at IS NULL);
CREATE UNIQUE INDEX "IDX_customer_group_name" ON public.customer_group USING btree (name) WHERE (deleted_at IS NULL);
CREATE UNIQUE INDEX "IDX_customer_group_name_unique" ON public.customer_group USING btree (name) WHERE (deleted_at IS NULL);


-- public.fulfillment_address definition

-- Drop table

-- DROP TABLE public.fulfillment_address;

CREATE TABLE public.fulfillment_address (
	id text NOT NULL,
	company text NULL,
	first_name text NULL,
	last_name text NULL,
	address_1 text NULL,
	address_2 text NULL,
	city text NULL,
	country_code text NULL,
	province text NULL,
	postal_code text NULL,
	phone text NULL,
	metadata jsonb NULL,
	created_at timestamptz DEFAULT now() NOT NULL,
	updated_at timestamptz DEFAULT now() NOT NULL,
	deleted_at timestamptz NULL,
	CONSTRAINT fulfillment_address_pkey PRIMARY KEY (id)
);
CREATE INDEX "IDX_fulfillment_address_deleted_at" ON public.fulfillment_address USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


-- public.fulfillment_provider definition

-- Drop table

-- DROP TABLE public.fulfillment_provider;

CREATE TABLE public.fulfillment_provider (
	id text NOT NULL,
	is_enabled bool DEFAULT true NOT NULL,
	created_at timestamptz DEFAULT now() NOT NULL,
	updated_at timestamptz DEFAULT now() NOT NULL,
	deleted_at timestamptz NULL,
	CONSTRAINT fulfillment_provider_pkey PRIMARY KEY (id)
);
CREATE INDEX "IDX_fulfillment_provider_deleted_at" ON public.fulfillment_provider USING btree (deleted_at) WHERE (deleted_at IS NULL);


-- public.fulfillment_set definition

-- Drop table

-- DROP TABLE public.fulfillment_set;

CREATE TABLE public.fulfillment_set (
	id text NOT NULL,
	"name" text NOT NULL,
	"type" text NOT NULL,
	metadata jsonb NULL,
	created_at timestamptz DEFAULT now() NOT NULL,
	updated_at timestamptz DEFAULT now() NOT NULL,
	deleted_at timestamptz NULL,
	CONSTRAINT fulfillment_set_pkey PRIMARY KEY (id)
);
CREATE INDEX "IDX_fulfillment_set_deleted_at" ON public.fulfillment_set USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);
CREATE UNIQUE INDEX "IDX_fulfillment_set_name_unique" ON public.fulfillment_set USING btree (name) WHERE (deleted_at IS NULL);


-- public.inventory_item definition

-- Drop table

-- DROP TABLE public.inventory_item;

CREATE TABLE public.inventory_item (
	id text NOT NULL,
	created_at timestamptz DEFAULT now() NOT NULL,
	updated_at timestamptz DEFAULT now() NOT NULL,
	deleted_at timestamptz NULL,
	sku text NULL,
	origin_country text NULL,
	hs_code text NULL,
	mid_code text NULL,
	material text NULL,
	weight int4 NULL,
	length int4 NULL,
	height int4 NULL,
	width int4 NULL,
	requires_shipping bool DEFAULT true NOT NULL,
	description text NULL,
	title text NULL,
	thumbnail text NULL,
	metadata jsonb NULL,
	CONSTRAINT inventory_item_pkey PRIMARY KEY (id)
);
CREATE INDEX "IDX_inventory_item_deleted_at" ON public.inventory_item USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);
CREATE UNIQUE INDEX "IDX_inventory_item_sku" ON public.inventory_item USING btree (sku) WHERE (deleted_at IS NULL);


-- public.invite definition

-- Drop table

-- DROP TABLE public.invite;

CREATE TABLE public.invite (
	id text NOT NULL,
	email text NOT NULL,
	accepted bool DEFAULT false NOT NULL,
	"token" text NOT NULL,
	expires_at timestamptz NOT NULL,
	metadata jsonb NULL,
	created_at timestamptz DEFAULT now() NOT NULL,
	updated_at timestamptz DEFAULT now() NOT NULL,
	deleted_at timestamptz NULL,
	CONSTRAINT invite_pkey PRIMARY KEY (id)
);
CREATE INDEX "IDX_invite_deleted_at" ON public.invite USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);
CREATE UNIQUE INDEX "IDX_invite_email_unique" ON public.invite USING btree (email) WHERE (deleted_at IS NULL);
CREATE INDEX "IDX_invite_token" ON public.invite USING btree (token) WHERE (deleted_at IS NULL);


-- public.link_module_migrations definition

-- Drop table

-- DROP TABLE public.link_module_migrations;

CREATE TABLE public.link_module_migrations (
	id serial4 NOT NULL,
	table_name varchar(255) NOT NULL,
	link_descriptor jsonb DEFAULT '{}'::jsonb NOT NULL,
	created_at timestamp DEFAULT CURRENT_TIMESTAMP NULL,
	CONSTRAINT link_module_migrations_pkey PRIMARY KEY (id),
	CONSTRAINT link_module_migrations_table_name_key UNIQUE (table_name)
);


-- public.location_fulfillment_provider definition

-- Drop table

-- DROP TABLE public.location_fulfillment_provider;

CREATE TABLE public.location_fulfillment_provider (
	stock_location_id varchar(255) NOT NULL,
	fulfillment_provider_id varchar(255) NOT NULL,
	id varchar(255) NOT NULL,
	created_at timestamptz(0) DEFAULT CURRENT_TIMESTAMP NOT NULL,
	updated_at timestamptz(0) DEFAULT CURRENT_TIMESTAMP NOT NULL,
	deleted_at timestamptz(0) NULL,
	CONSTRAINT location_fulfillment_provider_pkey PRIMARY KEY (stock_location_id, fulfillment_provider_id)
);
CREATE INDEX "IDX_deleted_at_-1e5992737" ON public.location_fulfillment_provider USING btree (deleted_at);
CREATE INDEX "IDX_fulfillment_provider_id_-1e5992737" ON public.location_fulfillment_provider USING btree (fulfillment_provider_id);
CREATE INDEX "IDX_id_-1e5992737" ON public.location_fulfillment_provider USING btree (id);
CREATE INDEX "IDX_stock_location_id_-1e5992737" ON public.location_fulfillment_provider USING btree (stock_location_id);


-- public.location_fulfillment_set definition

-- Drop table

-- DROP TABLE public.location_fulfillment_set;

CREATE TABLE public.location_fulfillment_set (
	stock_location_id varchar(255) NOT NULL,
	fulfillment_set_id varchar(255) NOT NULL,
	id varchar(255) NOT NULL,
	created_at timestamptz(0) DEFAULT CURRENT_TIMESTAMP NOT NULL,
	updated_at timestamptz(0) DEFAULT CURRENT_TIMESTAMP NOT NULL,
	deleted_at timestamptz(0) NULL,
	CONSTRAINT location_fulfillment_set_pkey PRIMARY KEY (stock_location_id, fulfillment_set_id)
);
CREATE INDEX "IDX_deleted_at_-e88adb96" ON public.location_fulfillment_set USING btree (deleted_at);
CREATE INDEX "IDX_fulfillment_set_id_-e88adb96" ON public.location_fulfillment_set USING btree (fulfillment_set_id);
CREATE INDEX "IDX_id_-e88adb96" ON public.location_fulfillment_set USING btree (id);
CREATE INDEX "IDX_stock_location_id_-e88adb96" ON public.location_fulfillment_set USING btree (stock_location_id);


-- public.mikro_orm_migrations definition

-- Drop table

-- DROP TABLE public.mikro_orm_migrations;

CREATE TABLE public.mikro_orm_migrations (
	id serial4 NOT NULL,
	"name" varchar(255) NULL,
	executed_at timestamptz DEFAULT CURRENT_TIMESTAMP NULL,
	CONSTRAINT mikro_orm_migrations_pkey PRIMARY KEY (id)
);


-- public.notification_provider definition

-- Drop table

-- DROP TABLE public.notification_provider;

CREATE TABLE public.notification_provider (
	id text NOT NULL,
	handle text NOT NULL,
	"name" text NOT NULL,
	is_enabled bool DEFAULT true NOT NULL,
	channels _text DEFAULT '{}'::text[] NOT NULL,
	created_at timestamptz DEFAULT now() NOT NULL,
	updated_at timestamptz DEFAULT now() NOT NULL,
	deleted_at timestamptz NULL,
	CONSTRAINT notification_provider_pkey PRIMARY KEY (id)
);


-- public.order_address definition

-- Drop table

-- DROP TABLE public.order_address;

CREATE TABLE public.order_address (
	id text NOT NULL,
	customer_id text NULL,
	company text NULL,
	first_name text NULL,
	last_name text NULL,
	address_1 text NULL,
	address_2 text NULL,
	city text NULL,
	country_code text NULL,
	province text NULL,
	postal_code text NULL,
	phone text NULL,
	metadata jsonb NULL,
	created_at timestamptz DEFAULT now() NOT NULL,
	updated_at timestamptz DEFAULT now() NOT NULL,
	CONSTRAINT order_address_pkey PRIMARY KEY (id)
);
CREATE INDEX "IDX_order_address_customer_id" ON public.order_address USING btree (customer_id);


-- public.order_cart definition

-- Drop table

-- DROP TABLE public.order_cart;

CREATE TABLE public.order_cart (
	order_id varchar(255) NOT NULL,
	cart_id varchar(255) NOT NULL,
	id varchar(255) NOT NULL,
	created_at timestamptz(0) DEFAULT CURRENT_TIMESTAMP NOT NULL,
	updated_at timestamptz(0) DEFAULT CURRENT_TIMESTAMP NOT NULL,
	deleted_at timestamptz(0) NULL,
	CONSTRAINT order_cart_pkey PRIMARY KEY (order_id, cart_id)
);
CREATE INDEX "IDX_cart_id_-71069c16" ON public.order_cart USING btree (cart_id);
CREATE INDEX "IDX_deleted_at_-71069c16" ON public.order_cart USING btree (deleted_at);
CREATE INDEX "IDX_id_-71069c16" ON public.order_cart USING btree (id);
CREATE INDEX "IDX_order_id_-71069c16" ON public.order_cart USING btree (order_id);


-- public.order_claim definition

-- Drop table

-- DROP TABLE public.order_claim;

CREATE TABLE public.order_claim (
	id text NOT NULL,
	order_id text NOT NULL,
	return_id text NULL,
	order_version int4 NOT NULL,
	display_id serial4 NOT NULL,
	"type" public.order_claim_type_enum NOT NULL,
	no_notification bool NULL,
	refund_amount numeric NULL,
	raw_refund_amount jsonb NULL,
	metadata jsonb NULL,
	created_at timestamptz DEFAULT now() NOT NULL,
	updated_at timestamptz DEFAULT now() NOT NULL,
	deleted_at timestamptz NULL,
	canceled_at timestamptz NULL,
	created_by text NULL,
	CONSTRAINT order_claim_pkey PRIMARY KEY (id)
);
CREATE INDEX "IDX_order_claim_deleted_at" ON public.order_claim USING btree (deleted_at) WHERE (deleted_at IS NULL);
CREATE INDEX "IDX_order_claim_display_id" ON public.order_claim USING btree (display_id) WHERE (deleted_at IS NULL);
CREATE INDEX "IDX_order_claim_order_id" ON public.order_claim USING btree (order_id) WHERE (deleted_at IS NULL);
CREATE INDEX "IDX_order_claim_return_id" ON public.order_claim USING btree (return_id) WHERE ((return_id IS NOT NULL) AND (deleted_at IS NULL));


-- public.order_claim_item definition

-- Drop table

-- DROP TABLE public.order_claim_item;

CREATE TABLE public.order_claim_item (
	id text NOT NULL,
	claim_id text NOT NULL,
	item_id text NOT NULL,
	is_additional_item bool DEFAULT false NOT NULL,
	reason public.claim_reason_enum NULL,
	quantity numeric NOT NULL,
	raw_quantity jsonb NOT NULL,
	note text NULL,
	metadata jsonb NULL,
	created_at timestamptz DEFAULT now() NOT NULL,
	updated_at timestamptz DEFAULT now() NOT NULL,
	deleted_at timestamptz NULL,
	CONSTRAINT order_claim_item_pkey PRIMARY KEY (id)
);
CREATE INDEX "IDX_order_claim_item_claim_id" ON public.order_claim_item USING btree (claim_id) WHERE (deleted_at IS NULL);
CREATE INDEX "IDX_order_claim_item_deleted_at" ON public.order_claim_item USING btree (deleted_at) WHERE (deleted_at IS NULL);
CREATE INDEX "IDX_order_claim_item_item_id" ON public.order_claim_item USING btree (item_id) WHERE (deleted_at IS NULL);


-- public.order_claim_item_image definition

-- Drop table

-- DROP TABLE public.order_claim_item_image;

CREATE TABLE public.order_claim_item_image (
	id text NOT NULL,
	claim_item_id text NOT NULL,
	url text NOT NULL,
	metadata jsonb NULL,
	created_at timestamptz DEFAULT now() NOT NULL,
	updated_at timestamptz DEFAULT now() NOT NULL,
	deleted_at timestamptz NULL,
	CONSTRAINT order_claim_item_image_pkey PRIMARY KEY (id)
);
CREATE INDEX "IDX_order_claim_item_image_claim_item_id" ON public.order_claim_item_image USING btree (claim_item_id) WHERE (deleted_at IS NOT NULL);
CREATE INDEX "IDX_order_claim_item_image_deleted_at" ON public.order_claim_item_image USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


-- public.order_exchange definition

-- Drop table

-- DROP TABLE public.order_exchange;

CREATE TABLE public.order_exchange (
	id text NOT NULL,
	order_id text NOT NULL,
	return_id text NULL,
	order_version int4 NOT NULL,
	display_id serial4 NOT NULL,
	no_notification bool NULL,
	allow_backorder bool DEFAULT false NOT NULL,
	difference_due numeric NULL,
	raw_difference_due jsonb NULL,
	metadata jsonb NULL,
	created_at timestamptz DEFAULT now() NOT NULL,
	updated_at timestamptz DEFAULT now() NOT NULL,
	deleted_at timestamptz NULL,
	canceled_at timestamptz NULL,
	created_by text NULL,
	CONSTRAINT order_exchange_pkey PRIMARY KEY (id)
);
CREATE INDEX "IDX_order_exchange_deleted_at" ON public.order_exchange USING btree (deleted_at) WHERE (deleted_at IS NULL);
CREATE INDEX "IDX_order_exchange_display_id" ON public.order_exchange USING btree (display_id) WHERE (deleted_at IS NULL);
CREATE INDEX "IDX_order_exchange_order_id" ON public.order_exchange USING btree (order_id) WHERE (deleted_at IS NULL);
CREATE INDEX "IDX_order_exchange_return_id" ON public.order_exchange USING btree (return_id) WHERE ((return_id IS NOT NULL) AND (deleted_at IS NULL));


-- public.order_exchange_item definition

-- Drop table

-- DROP TABLE public.order_exchange_item;

CREATE TABLE public.order_exchange_item (
	id text NOT NULL,
	exchange_id text NOT NULL,
	item_id text NOT NULL,
	quantity numeric NOT NULL,
	raw_quantity jsonb NOT NULL,
	note text NULL,
	metadata jsonb NULL,
	created_at timestamptz DEFAULT now() NOT NULL,
	updated_at timestamptz DEFAULT now() NOT NULL,
	deleted_at timestamptz NULL,
	CONSTRAINT order_exchange_item_pkey PRIMARY KEY (id)
);
CREATE INDEX "IDX_order_exchange_item_deleted_at" ON public.order_exchange_item USING btree (deleted_at) WHERE (deleted_at IS NULL);
CREATE INDEX "IDX_order_exchange_item_exchange_id" ON public.order_exchange_item USING btree (exchange_id) WHERE (deleted_at IS NULL);
CREATE INDEX "IDX_order_exchange_item_item_id" ON public.order_exchange_item USING btree (item_id) WHERE (deleted_at IS NULL);


-- public.order_fulfillment definition

-- Drop table

-- DROP TABLE public.order_fulfillment;

CREATE TABLE public.order_fulfillment (
	order_id varchar(255) NOT NULL,
	fulfillment_id varchar(255) NOT NULL,
	id varchar(255) NOT NULL,
	created_at timestamptz(0) DEFAULT CURRENT_TIMESTAMP NOT NULL,
	updated_at timestamptz(0) DEFAULT CURRENT_TIMESTAMP NOT NULL,
	deleted_at timestamptz(0) NULL,
	CONSTRAINT order_fulfillment_pkey PRIMARY KEY (order_id, fulfillment_id)
);
CREATE INDEX "IDX_deleted_at_-e8d2543e" ON public.order_fulfillment USING btree (deleted_at);
CREATE INDEX "IDX_fulfillment_id_-e8d2543e" ON public.order_fulfillment USING btree (fulfillment_id);
CREATE INDEX "IDX_id_-e8d2543e" ON public.order_fulfillment USING btree (id);
CREATE INDEX "IDX_order_id_-e8d2543e" ON public.order_fulfillment USING btree (order_id);


-- public.order_payment_collection definition

-- Drop table

-- DROP TABLE public.order_payment_collection;

CREATE TABLE public.order_payment_collection (
	order_id varchar(255) NOT NULL,
	payment_collection_id varchar(255) NOT NULL,
	id varchar(255) NOT NULL,
	created_at timestamptz(0) DEFAULT CURRENT_TIMESTAMP NOT NULL,
	updated_at timestamptz(0) DEFAULT CURRENT_TIMESTAMP NOT NULL,
	deleted_at timestamptz(0) NULL,
	CONSTRAINT order_payment_collection_pkey PRIMARY KEY (order_id, payment_collection_id)
);
CREATE INDEX "IDX_deleted_at_f42b9949" ON public.order_payment_collection USING btree (deleted_at);
CREATE INDEX "IDX_id_f42b9949" ON public.order_payment_collection USING btree (id);
CREATE INDEX "IDX_order_id_f42b9949" ON public.order_payment_collection USING btree (order_id);
CREATE INDEX "IDX_payment_collection_id_f42b9949" ON public.order_payment_collection USING btree (payment_collection_id);


-- public.order_promotion definition

-- Drop table

-- DROP TABLE public.order_promotion;

CREATE TABLE public.order_promotion (
	order_id varchar(255) NOT NULL,
	promotion_id varchar(255) NOT NULL,
	id varchar(255) NOT NULL,
	created_at timestamptz(0) DEFAULT CURRENT_TIMESTAMP NOT NULL,
	updated_at timestamptz(0) DEFAULT CURRENT_TIMESTAMP NOT NULL,
	deleted_at timestamptz(0) NULL,
	CONSTRAINT order_promotion_pkey PRIMARY KEY (order_id, promotion_id)
);
CREATE INDEX "IDX_deleted_at_-71518339" ON public.order_promotion USING btree (deleted_at);
CREATE INDEX "IDX_id_-71518339" ON public.order_promotion USING btree (id);
CREATE INDEX "IDX_order_id_-71518339" ON public.order_promotion USING btree (order_id);
CREATE INDEX "IDX_promotion_id_-71518339" ON public.order_promotion USING btree (promotion_id);


-- public.order_shipping_method definition

-- Drop table

-- DROP TABLE public.order_shipping_method;

CREATE TABLE public.order_shipping_method (
	id text NOT NULL,
	"name" text NOT NULL,
	description jsonb NULL,
	amount numeric NOT NULL,
	raw_amount jsonb NOT NULL,
	is_tax_inclusive bool DEFAULT false NOT NULL,
	shipping_option_id text NULL,
	"data" jsonb NULL,
	metadata jsonb NULL,
	created_at timestamptz DEFAULT now() NOT NULL,
	updated_at timestamptz DEFAULT now() NOT NULL,
	deleted_at timestamptz NULL,
	is_custom_amount bool DEFAULT false NOT NULL,
	CONSTRAINT order_shipping_method_pkey PRIMARY KEY (id)
);
CREATE INDEX "IDX_order_shipping_method_shipping_option_id" ON public.order_shipping_method USING btree (shipping_option_id) WHERE (deleted_at IS NULL);


-- public.order_summary definition

-- Drop table

-- DROP TABLE public.order_summary;

CREATE TABLE public.order_summary (
	id text NOT NULL,
	order_id text NOT NULL,
	"version" int4 DEFAULT 1 NOT NULL,
	totals jsonb NULL,
	created_at timestamptz DEFAULT now() NOT NULL,
	updated_at timestamptz DEFAULT now() NOT NULL,
	deleted_at timestamptz NULL,
	CONSTRAINT order_summary_pkey PRIMARY KEY (id)
);
CREATE INDEX "IDX_order_summary_deleted_at" ON public.order_summary USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);
CREATE INDEX "IDX_order_summary_order_id_version" ON public.order_summary USING btree (order_id, version) WHERE (deleted_at IS NULL);


-- public.payment_collection definition

-- Drop table

-- DROP TABLE public.payment_collection;

CREATE TABLE public.payment_collection (
	id text NOT NULL,
	currency_code text NOT NULL,
	amount numeric NOT NULL,
	raw_amount jsonb NOT NULL,
	authorized_amount numeric NULL,
	raw_authorized_amount jsonb NULL,
	captured_amount numeric NULL,
	raw_captured_amount jsonb NULL,
	refunded_amount numeric NULL,
	raw_refunded_amount jsonb NULL,
	region_id text NOT NULL,
	created_at timestamptz DEFAULT now() NOT NULL,
	updated_at timestamptz DEFAULT now() NOT NULL,
	deleted_at timestamptz NULL,
	completed_at timestamptz NULL,
	status text DEFAULT 'not_paid'::text NOT NULL,
	metadata jsonb NULL,
	CONSTRAINT payment_collection_pkey PRIMARY KEY (id),
	CONSTRAINT payment_collection_status_check CHECK ((status = ANY (ARRAY['not_paid'::text, 'awaiting'::text, 'authorized'::text, 'partially_authorized'::text, 'canceled'::text])))
);
CREATE INDEX "IDX_payment_collection_deleted_at" ON public.payment_collection USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);
CREATE INDEX "IDX_payment_collection_region_id" ON public.payment_collection USING btree (region_id) WHERE (deleted_at IS NULL);


-- public.payment_method_token definition

-- Drop table

-- DROP TABLE public.payment_method_token;

CREATE TABLE public.payment_method_token (
	id text NOT NULL,
	provider_id text NOT NULL,
	"data" jsonb NULL,
	"name" text NOT NULL,
	type_detail text NULL,
	description_detail text NULL,
	metadata jsonb NULL,
	created_at timestamptz DEFAULT now() NOT NULL,
	updated_at timestamptz DEFAULT now() NOT NULL,
	deleted_at timestamptz NULL,
	CONSTRAINT payment_method_token_pkey PRIMARY KEY (id)
);
CREATE INDEX "IDX_payment_method_token_deleted_at" ON public.payment_method_token USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


-- public.payment_provider definition

-- Drop table

-- DROP TABLE public.payment_provider;

CREATE TABLE public.payment_provider (
	id text NOT NULL,
	is_enabled bool DEFAULT true NOT NULL,
	created_at timestamptz DEFAULT now() NOT NULL,
	updated_at timestamptz DEFAULT now() NOT NULL,
	deleted_at timestamptz NULL,
	CONSTRAINT payment_provider_pkey PRIMARY KEY (id)
);
CREATE INDEX "IDX_payment_provider_deleted_at" ON public.payment_provider USING btree (deleted_at) WHERE (deleted_at IS NULL);


-- public.price_list definition

-- Drop table

-- DROP TABLE public.price_list;

CREATE TABLE public.price_list (
	id text NOT NULL,
	status text DEFAULT 'draft'::text NOT NULL,
	starts_at timestamptz NULL,
	ends_at timestamptz NULL,
	rules_count int4 DEFAULT 0 NULL,
	title text NOT NULL,
	description text NOT NULL,
	"type" text DEFAULT 'sale'::text NOT NULL,
	created_at timestamptz DEFAULT now() NOT NULL,
	updated_at timestamptz DEFAULT now() NOT NULL,
	deleted_at timestamptz NULL,
	CONSTRAINT price_list_pkey PRIMARY KEY (id),
	CONSTRAINT price_list_status_check CHECK ((status = ANY (ARRAY['active'::text, 'draft'::text]))),
	CONSTRAINT price_list_type_check CHECK ((type = ANY (ARRAY['sale'::text, 'override'::text])))
);
CREATE INDEX "IDX_price_list_deleted_at" ON public.price_list USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


-- public.price_preference definition

-- Drop table

-- DROP TABLE public.price_preference;

CREATE TABLE public.price_preference (
	id text NOT NULL,
	"attribute" text NOT NULL,
	value text NULL,
	is_tax_inclusive bool DEFAULT false NOT NULL,
	created_at timestamptz DEFAULT now() NOT NULL,
	updated_at timestamptz DEFAULT now() NOT NULL,
	deleted_at timestamptz NULL,
	CONSTRAINT price_preference_pkey PRIMARY KEY (id)
);
CREATE UNIQUE INDEX "IDX_price_preference_attribute_value" ON public.price_preference USING btree (attribute, value) WHERE (deleted_at IS NULL);
CREATE INDEX "IDX_price_preference_deleted_at" ON public.price_preference USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


-- public.price_set definition

-- Drop table

-- DROP TABLE public.price_set;

CREATE TABLE public.price_set (
	id text NOT NULL,
	created_at timestamptz DEFAULT now() NOT NULL,
	updated_at timestamptz DEFAULT now() NOT NULL,
	deleted_at timestamptz NULL,
	CONSTRAINT price_set_pkey PRIMARY KEY (id)
);
CREATE INDEX "IDX_price_set_deleted_at" ON public.price_set USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


-- public.product_collection definition

-- Drop table

-- DROP TABLE public.product_collection;

CREATE TABLE public.product_collection (
	id text NOT NULL,
	title text NOT NULL,
	handle text NOT NULL,
	metadata jsonb NULL,
	created_at timestamptz DEFAULT now() NOT NULL,
	updated_at timestamptz DEFAULT now() NOT NULL,
	deleted_at timestamptz NULL,
	CONSTRAINT product_collection_pkey PRIMARY KEY (id)
);
CREATE UNIQUE INDEX "IDX_collection_handle_unique" ON public.product_collection USING btree (handle) WHERE (deleted_at IS NULL);
CREATE INDEX "IDX_product_category_deleted_at" ON public.product_collection USING btree (deleted_at);
CREATE INDEX "IDX_product_collection_deleted_at" ON public.product_collection USING btree (deleted_at);


-- public.product_sales_channel definition

-- Drop table

-- DROP TABLE public.product_sales_channel;

CREATE TABLE public.product_sales_channel (
	product_id varchar(255) NOT NULL,
	sales_channel_id varchar(255) NOT NULL,
	id varchar(255) NOT NULL,
	created_at timestamptz(0) DEFAULT CURRENT_TIMESTAMP NOT NULL,
	updated_at timestamptz(0) DEFAULT CURRENT_TIMESTAMP NOT NULL,
	deleted_at timestamptz(0) NULL,
	CONSTRAINT product_sales_channel_pkey PRIMARY KEY (product_id, sales_channel_id)
);
CREATE INDEX "IDX_deleted_at_20b454295" ON public.product_sales_channel USING btree (deleted_at);
CREATE INDEX "IDX_id_20b454295" ON public.product_sales_channel USING btree (id);
CREATE INDEX "IDX_product_id_20b454295" ON public.product_sales_channel USING btree (product_id);
CREATE INDEX "IDX_sales_channel_id_20b454295" ON public.product_sales_channel USING btree (sales_channel_id);


-- public.product_tag definition

-- Drop table

-- DROP TABLE public.product_tag;

CREATE TABLE public.product_tag (
	id text NOT NULL,
	value text NOT NULL,
	metadata jsonb NULL,
	created_at timestamptz DEFAULT now() NOT NULL,
	updated_at timestamptz DEFAULT now() NOT NULL,
	deleted_at timestamptz NULL,
	CONSTRAINT product_tag_pkey PRIMARY KEY (id)
);
CREATE INDEX "IDX_product_tag_deleted_at" ON public.product_tag USING btree (deleted_at);
CREATE UNIQUE INDEX "IDX_tag_value_unique" ON public.product_tag USING btree (value) WHERE (deleted_at IS NULL);


-- public.product_type definition

-- Drop table

-- DROP TABLE public.product_type;

CREATE TABLE public.product_type (
	id text NOT NULL,
	value text NOT NULL,
	metadata json NULL,
	created_at timestamptz DEFAULT now() NOT NULL,
	updated_at timestamptz DEFAULT now() NOT NULL,
	deleted_at timestamptz NULL,
	CONSTRAINT product_type_pkey PRIMARY KEY (id)
);
CREATE INDEX "IDX_product_type_deleted_at" ON public.product_type USING btree (deleted_at);
CREATE UNIQUE INDEX "IDX_type_value_unique" ON public.product_type USING btree (value) WHERE (deleted_at IS NULL);


-- public.product_variant_inventory_item definition

-- Drop table

-- DROP TABLE public.product_variant_inventory_item;

CREATE TABLE public.product_variant_inventory_item (
	variant_id varchar(255) NOT NULL,
	inventory_item_id varchar(255) NOT NULL,
	id varchar(255) NOT NULL,
	required_quantity int4 DEFAULT 1 NOT NULL,
	created_at timestamptz(0) DEFAULT CURRENT_TIMESTAMP NOT NULL,
	updated_at timestamptz(0) DEFAULT CURRENT_TIMESTAMP NOT NULL,
	deleted_at timestamptz(0) NULL,
	CONSTRAINT product_variant_inventory_item_pkey PRIMARY KEY (variant_id, inventory_item_id)
);
CREATE INDEX "IDX_deleted_at_17b4c4e35" ON public.product_variant_inventory_item USING btree (deleted_at);
CREATE INDEX "IDX_id_17b4c4e35" ON public.product_variant_inventory_item USING btree (id);
CREATE INDEX "IDX_inventory_item_id_17b4c4e35" ON public.product_variant_inventory_item USING btree (inventory_item_id);
CREATE INDEX "IDX_variant_id_17b4c4e35" ON public.product_variant_inventory_item USING btree (variant_id);


-- public.product_variant_price_set definition

-- Drop table

-- DROP TABLE public.product_variant_price_set;

CREATE TABLE public.product_variant_price_set (
	variant_id varchar(255) NOT NULL,
	price_set_id varchar(255) NOT NULL,
	id varchar(255) NOT NULL,
	created_at timestamptz(0) DEFAULT CURRENT_TIMESTAMP NOT NULL,
	updated_at timestamptz(0) DEFAULT CURRENT_TIMESTAMP NOT NULL,
	deleted_at timestamptz(0) NULL,
	CONSTRAINT product_variant_price_set_pkey PRIMARY KEY (variant_id, price_set_id)
);
CREATE INDEX "IDX_deleted_at_52b23597" ON public.product_variant_price_set USING btree (deleted_at);
CREATE INDEX "IDX_id_52b23597" ON public.product_variant_price_set USING btree (id);
CREATE INDEX "IDX_price_set_id_52b23597" ON public.product_variant_price_set USING btree (price_set_id);
CREATE INDEX "IDX_variant_id_52b23597" ON public.product_variant_price_set USING btree (variant_id);


-- public.promotion_campaign definition

-- Drop table

-- DROP TABLE public.promotion_campaign;

CREATE TABLE public.promotion_campaign (
	id text NOT NULL,
	"name" text NOT NULL,
	description text NULL,
	campaign_identifier text NOT NULL,
	starts_at timestamptz NULL,
	ends_at timestamptz NULL,
	created_at timestamptz DEFAULT now() NOT NULL,
	updated_at timestamptz DEFAULT now() NOT NULL,
	deleted_at timestamptz NULL,
	CONSTRAINT promotion_campaign_pkey PRIMARY KEY (id)
);
CREATE UNIQUE INDEX "IDX_promotion_campaign_campaign_identifier_unique" ON public.promotion_campaign USING btree (campaign_identifier) WHERE (deleted_at IS NULL);
CREATE INDEX "IDX_promotion_campaign_deleted_at" ON public.promotion_campaign USING btree (deleted_at) WHERE (deleted_at IS NULL);


-- public.promotion_rule definition

-- Drop table

-- DROP TABLE public.promotion_rule;

CREATE TABLE public.promotion_rule (
	id text NOT NULL,
	description text NULL,
	"attribute" text NOT NULL,
	"operator" text NOT NULL,
	created_at timestamptz DEFAULT now() NOT NULL,
	updated_at timestamptz DEFAULT now() NOT NULL,
	deleted_at timestamptz NULL,
	CONSTRAINT promotion_rule_operator_check CHECK ((operator = ANY (ARRAY['gte'::text, 'lte'::text, 'gt'::text, 'lt'::text, 'eq'::text, 'ne'::text, 'in'::text]))),
	CONSTRAINT promotion_rule_pkey PRIMARY KEY (id)
);
CREATE INDEX "IDX_promotion_rule_attribute" ON public.promotion_rule USING btree (attribute);
CREATE INDEX "IDX_promotion_rule_deleted_at" ON public.promotion_rule USING btree (deleted_at) WHERE (deleted_at IS NULL);
CREATE INDEX "IDX_promotion_rule_operator" ON public.promotion_rule USING btree (operator);


-- public.publishable_api_key_sales_channel definition

-- Drop table

-- DROP TABLE public.publishable_api_key_sales_channel;

CREATE TABLE public.publishable_api_key_sales_channel (
	publishable_key_id varchar(255) NOT NULL,
	sales_channel_id varchar(255) NOT NULL,
	id varchar(255) NOT NULL,
	created_at timestamptz(0) DEFAULT CURRENT_TIMESTAMP NOT NULL,
	updated_at timestamptz(0) DEFAULT CURRENT_TIMESTAMP NOT NULL,
	deleted_at timestamptz(0) NULL,
	CONSTRAINT publishable_api_key_sales_channel_pkey PRIMARY KEY (publishable_key_id, sales_channel_id)
);
CREATE INDEX "IDX_deleted_at_-1d67bae40" ON public.publishable_api_key_sales_channel USING btree (deleted_at);
CREATE INDEX "IDX_id_-1d67bae40" ON public.publishable_api_key_sales_channel USING btree (id);
CREATE INDEX "IDX_publishable_key_id_-1d67bae40" ON public.publishable_api_key_sales_channel USING btree (publishable_key_id);
CREATE INDEX "IDX_sales_channel_id_-1d67bae40" ON public.publishable_api_key_sales_channel USING btree (sales_channel_id);


-- public.refund_reason definition

-- Drop table

-- DROP TABLE public.refund_reason;

CREATE TABLE public.refund_reason (
	id text NOT NULL,
	"label" text NOT NULL,
	description text NULL,
	metadata jsonb NULL,
	created_at timestamptz DEFAULT now() NOT NULL,
	updated_at timestamptz DEFAULT now() NOT NULL,
	deleted_at timestamptz NULL,
	CONSTRAINT refund_reason_pkey PRIMARY KEY (id)
);
CREATE INDEX "IDX_refund_reason_deleted_at" ON public.refund_reason USING btree (deleted_at) WHERE (deleted_at IS NULL);


-- public.region definition

-- Drop table

-- DROP TABLE public.region;

CREATE TABLE public.region (
	id text NOT NULL,
	"name" text NOT NULL,
	currency_code text NOT NULL,
	metadata jsonb NULL,
	created_at timestamptz DEFAULT now() NOT NULL,
	updated_at timestamptz DEFAULT now() NOT NULL,
	deleted_at timestamptz NULL,
	automatic_taxes bool DEFAULT true NOT NULL,
	CONSTRAINT region_pkey PRIMARY KEY (id)
);
CREATE INDEX "IDX_region_deleted_at" ON public.region USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


-- public.region_payment_provider definition

-- Drop table

-- DROP TABLE public.region_payment_provider;

CREATE TABLE public.region_payment_provider (
	region_id varchar(255) NOT NULL,
	payment_provider_id varchar(255) NOT NULL,
	id varchar(255) NOT NULL,
	created_at timestamptz(0) DEFAULT CURRENT_TIMESTAMP NOT NULL,
	updated_at timestamptz(0) DEFAULT CURRENT_TIMESTAMP NOT NULL,
	deleted_at timestamptz(0) NULL,
	CONSTRAINT region_payment_provider_pkey PRIMARY KEY (region_id, payment_provider_id)
);
CREATE INDEX "IDX_deleted_at_1c934dab0" ON public.region_payment_provider USING btree (deleted_at);
CREATE INDEX "IDX_id_1c934dab0" ON public.region_payment_provider USING btree (id);
CREATE INDEX "IDX_payment_provider_id_1c934dab0" ON public.region_payment_provider USING btree (payment_provider_id);
CREATE INDEX "IDX_region_id_1c934dab0" ON public.region_payment_provider USING btree (region_id);


-- public."return" definition

-- Drop table

-- DROP TABLE public."return";

CREATE TABLE public."return" (
	id text NOT NULL,
	order_id text NOT NULL,
	claim_id text NULL,
	exchange_id text NULL,
	order_version int4 NOT NULL,
	display_id serial4 NOT NULL,
	status public.return_status_enum DEFAULT 'open'::return_status_enum NOT NULL,
	no_notification bool NULL,
	refund_amount numeric NULL,
	raw_refund_amount jsonb NULL,
	metadata jsonb NULL,
	created_at timestamptz DEFAULT now() NOT NULL,
	updated_at timestamptz DEFAULT now() NOT NULL,
	deleted_at timestamptz NULL,
	received_at timestamptz NULL,
	canceled_at timestamptz NULL,
	location_id text NULL,
	requested_at timestamptz NULL,
	created_by text NULL,
	CONSTRAINT return_pkey PRIMARY KEY (id)
);
CREATE INDEX "IDX_return_claim_id" ON public.return USING btree (claim_id) WHERE ((claim_id IS NOT NULL) AND (deleted_at IS NULL));
CREATE INDEX "IDX_return_display_id" ON public.return USING btree (display_id) WHERE (deleted_at IS NULL);
CREATE INDEX "IDX_return_exchange_id" ON public.return USING btree (exchange_id) WHERE ((exchange_id IS NOT NULL) AND (deleted_at IS NULL));
CREATE INDEX "IDX_return_order_id" ON public.return USING btree (order_id) WHERE (deleted_at IS NULL);


-- public.return_fulfillment definition

-- Drop table

-- DROP TABLE public.return_fulfillment;

CREATE TABLE public.return_fulfillment (
	return_id varchar(255) NOT NULL,
	fulfillment_id varchar(255) NOT NULL,
	id varchar(255) NOT NULL,
	created_at timestamptz(0) DEFAULT CURRENT_TIMESTAMP NOT NULL,
	updated_at timestamptz(0) DEFAULT CURRENT_TIMESTAMP NOT NULL,
	deleted_at timestamptz(0) NULL,
	CONSTRAINT return_fulfillment_pkey PRIMARY KEY (return_id, fulfillment_id)
);
CREATE INDEX "IDX_deleted_at_-31ea43a" ON public.return_fulfillment USING btree (deleted_at);
CREATE INDEX "IDX_fulfillment_id_-31ea43a" ON public.return_fulfillment USING btree (fulfillment_id);
CREATE INDEX "IDX_id_-31ea43a" ON public.return_fulfillment USING btree (id);
CREATE INDEX "IDX_return_id_-31ea43a" ON public.return_fulfillment USING btree (return_id);


-- public.return_item definition

-- Drop table

-- DROP TABLE public.return_item;

CREATE TABLE public.return_item (
	id text NOT NULL,
	return_id text NOT NULL,
	reason_id text NULL,
	item_id text NOT NULL,
	quantity numeric NOT NULL,
	raw_quantity jsonb NOT NULL,
	received_quantity numeric DEFAULT 0 NOT NULL,
	raw_received_quantity jsonb NOT NULL,
	note text NULL,
	metadata jsonb NULL,
	created_at timestamptz DEFAULT now() NOT NULL,
	updated_at timestamptz DEFAULT now() NOT NULL,
	deleted_at timestamptz NULL,
	damaged_quantity numeric DEFAULT 0 NOT NULL,
	raw_damaged_quantity jsonb NOT NULL,
	CONSTRAINT return_item_pkey PRIMARY KEY (id)
);
CREATE INDEX "IDX_return_item_deleted_at" ON public.return_item USING btree (deleted_at) WHERE (deleted_at IS NULL);
CREATE INDEX "IDX_return_item_item_id" ON public.return_item USING btree (item_id) WHERE (deleted_at IS NULL);
CREATE INDEX "IDX_return_item_reason_id" ON public.return_item USING btree (reason_id) WHERE (deleted_at IS NULL);
CREATE INDEX "IDX_return_item_return_id" ON public.return_item USING btree (return_id) WHERE (deleted_at IS NULL);


-- public.sales_channel definition

-- Drop table

-- DROP TABLE public.sales_channel;

CREATE TABLE public.sales_channel (
	id text NOT NULL,
	"name" text NOT NULL,
	description text NULL,
	is_disabled bool DEFAULT false NOT NULL,
	metadata jsonb NULL,
	created_at timestamptz DEFAULT now() NOT NULL,
	updated_at timestamptz DEFAULT now() NOT NULL,
	deleted_at timestamptz NULL,
	CONSTRAINT sales_channel_pkey PRIMARY KEY (id)
);
CREATE INDEX "IDX_sales_channel_deleted_at" ON public.sales_channel USING btree (deleted_at);


-- public.sales_channel_stock_location definition

-- Drop table

-- DROP TABLE public.sales_channel_stock_location;

CREATE TABLE public.sales_channel_stock_location (
	sales_channel_id varchar(255) NOT NULL,
	stock_location_id varchar(255) NOT NULL,
	id varchar(255) NOT NULL,
	created_at timestamptz(0) DEFAULT CURRENT_TIMESTAMP NOT NULL,
	updated_at timestamptz(0) DEFAULT CURRENT_TIMESTAMP NOT NULL,
	deleted_at timestamptz(0) NULL,
	CONSTRAINT sales_channel_stock_location_pkey PRIMARY KEY (sales_channel_id, stock_location_id)
);
CREATE INDEX "IDX_deleted_at_26d06f470" ON public.sales_channel_stock_location USING btree (deleted_at);
CREATE INDEX "IDX_id_26d06f470" ON public.sales_channel_stock_location USING btree (id);
CREATE INDEX "IDX_sales_channel_id_26d06f470" ON public.sales_channel_stock_location USING btree (sales_channel_id);
CREATE INDEX "IDX_stock_location_id_26d06f470" ON public.sales_channel_stock_location USING btree (stock_location_id);


-- public.shipping_option_price_set definition

-- Drop table

-- DROP TABLE public.shipping_option_price_set;

CREATE TABLE public.shipping_option_price_set (
	shipping_option_id varchar(255) NOT NULL,
	price_set_id varchar(255) NOT NULL,
	id varchar(255) NOT NULL,
	created_at timestamptz(0) DEFAULT CURRENT_TIMESTAMP NOT NULL,
	updated_at timestamptz(0) DEFAULT CURRENT_TIMESTAMP NOT NULL,
	deleted_at timestamptz(0) NULL,
	CONSTRAINT shipping_option_price_set_pkey PRIMARY KEY (shipping_option_id, price_set_id)
);
CREATE INDEX "IDX_deleted_at_ba32fa9c" ON public.shipping_option_price_set USING btree (deleted_at);
CREATE INDEX "IDX_id_ba32fa9c" ON public.shipping_option_price_set USING btree (id);
CREATE INDEX "IDX_price_set_id_ba32fa9c" ON public.shipping_option_price_set USING btree (price_set_id);
CREATE INDEX "IDX_shipping_option_id_ba32fa9c" ON public.shipping_option_price_set USING btree (shipping_option_id);


-- public.shipping_option_type definition

-- Drop table

-- DROP TABLE public.shipping_option_type;

CREATE TABLE public.shipping_option_type (
	id text NOT NULL,
	"label" text NOT NULL,
	description text NULL,
	code text NOT NULL,
	created_at timestamptz DEFAULT now() NOT NULL,
	updated_at timestamptz DEFAULT now() NOT NULL,
	deleted_at timestamptz NULL,
	CONSTRAINT shipping_option_type_pkey PRIMARY KEY (id)
);
CREATE INDEX "IDX_shipping_option_type_deleted_at" ON public.shipping_option_type USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


-- public.shipping_profile definition

-- Drop table

-- DROP TABLE public.shipping_profile;

CREATE TABLE public.shipping_profile (
	id text NOT NULL,
	"name" text NOT NULL,
	"type" text NOT NULL,
	metadata jsonb NULL,
	created_at timestamptz DEFAULT now() NOT NULL,
	updated_at timestamptz DEFAULT now() NOT NULL,
	deleted_at timestamptz NULL,
	CONSTRAINT shipping_profile_pkey PRIMARY KEY (id)
);
CREATE INDEX "IDX_shipping_profile_deleted_at" ON public.shipping_profile USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);
CREATE UNIQUE INDEX "IDX_shipping_profile_name_unique" ON public.shipping_profile USING btree (name) WHERE (deleted_at IS NULL);


-- public.stock_location_address definition

-- Drop table

-- DROP TABLE public.stock_location_address;

CREATE TABLE public.stock_location_address (
	id text NOT NULL,
	created_at timestamptz DEFAULT now() NOT NULL,
	updated_at timestamptz DEFAULT now() NOT NULL,
	deleted_at timestamptz NULL,
	address_1 text NOT NULL,
	address_2 text NULL,
	company text NULL,
	city text NULL,
	country_code text NOT NULL,
	phone text NULL,
	province text NULL,
	postal_code text NULL,
	metadata jsonb NULL,
	CONSTRAINT stock_location_address_pkey PRIMARY KEY (id)
);
CREATE INDEX "IDX_stock_location_address_deleted_at" ON public.stock_location_address USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


-- public.store definition

-- Drop table

-- DROP TABLE public.store;

CREATE TABLE public.store (
	id text NOT NULL,
	"name" text DEFAULT 'Medusa Store'::text NOT NULL,
	default_sales_channel_id text NULL,
	default_region_id text NULL,
	default_location_id text NULL,
	metadata jsonb NULL,
	created_at timestamptz DEFAULT now() NOT NULL,
	updated_at timestamptz DEFAULT now() NOT NULL,
	deleted_at timestamptz NULL,
	CONSTRAINT store_pkey PRIMARY KEY (id)
);
CREATE INDEX "IDX_store_deleted_at" ON public.store USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


-- public.tax_provider definition

-- Drop table

-- DROP TABLE public.tax_provider;

CREATE TABLE public.tax_provider (
	id text NOT NULL,
	is_enabled bool DEFAULT true NOT NULL,
	created_at timestamptz DEFAULT now() NOT NULL,
	updated_at timestamptz DEFAULT now() NOT NULL,
	deleted_at timestamptz NULL,
	CONSTRAINT tax_provider_pkey PRIMARY KEY (id)
);
CREATE INDEX "IDX_tax_provider_deleted_at" ON public.tax_provider USING btree (deleted_at) WHERE (deleted_at IS NULL);


-- public."user" definition

-- Drop table

-- DROP TABLE public."user";

CREATE TABLE public."user" (
	id text NOT NULL,
	first_name text NULL,
	last_name text NULL,
	email text NOT NULL,
	avatar_url text NULL,
	metadata jsonb NULL,
	created_at timestamptz DEFAULT now() NOT NULL,
	updated_at timestamptz DEFAULT now() NOT NULL,
	deleted_at timestamptz NULL,
	CONSTRAINT user_pkey PRIMARY KEY (id)
);
CREATE INDEX "IDX_user_deleted_at" ON public."user" USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);
CREATE UNIQUE INDEX "IDX_user_email_unique" ON public."user" USING btree (email) WHERE (deleted_at IS NULL);


-- public.workflow_execution definition

-- Drop table

-- DROP TABLE public.workflow_execution;

CREATE TABLE public.workflow_execution (
	id varchar NOT NULL,
	workflow_id varchar NOT NULL,
	transaction_id varchar NOT NULL,
	execution jsonb NULL,
	context jsonb NULL,
	state varchar NOT NULL,
	created_at timestamp DEFAULT now() NOT NULL,
	updated_at timestamp DEFAULT now() NOT NULL,
	deleted_at timestamp NULL,
	CONSTRAINT "PK_workflow_execution_workflow_id_transaction_id" PRIMARY KEY (workflow_id, transaction_id)
);
CREATE INDEX "IDX_workflow_execution_deleted_at" ON public.workflow_execution USING btree (deleted_at) WHERE (deleted_at IS NULL);
CREATE INDEX "IDX_workflow_execution_id" ON public.workflow_execution USING btree (id) WHERE (deleted_at IS NULL);
CREATE INDEX "IDX_workflow_execution_state" ON public.workflow_execution USING btree (state) WHERE (deleted_at IS NULL);
CREATE INDEX "IDX_workflow_execution_transaction_id" ON public.workflow_execution USING btree (transaction_id) WHERE (deleted_at IS NULL);
CREATE INDEX "IDX_workflow_execution_workflow_id" ON public.workflow_execution USING btree (workflow_id) WHERE (deleted_at IS NULL);


-- public.cart definition

-- Drop table

-- DROP TABLE public.cart;

CREATE TABLE public.cart (
	id text NOT NULL,
	region_id text NULL,
	customer_id text NULL,
	sales_channel_id text NULL,
	email text NULL,
	currency_code text NOT NULL,
	shipping_address_id text NULL,
	billing_address_id text NULL,
	metadata jsonb NULL,
	created_at timestamptz DEFAULT now() NOT NULL,
	updated_at timestamptz DEFAULT now() NOT NULL,
	deleted_at timestamptz NULL,
	completed_at timestamptz NULL,
	CONSTRAINT cart_pkey PRIMARY KEY (id),
	CONSTRAINT cart_billing_address_id_foreign FOREIGN KEY (billing_address_id) REFERENCES public.cart_address(id) ON DELETE SET NULL ON UPDATE CASCADE,
	CONSTRAINT cart_shipping_address_id_foreign FOREIGN KEY (shipping_address_id) REFERENCES public.cart_address(id) ON DELETE SET NULL ON UPDATE CASCADE
);
CREATE INDEX "IDX_cart_billing_address_id" ON public.cart USING btree (billing_address_id) WHERE ((deleted_at IS NULL) AND (billing_address_id IS NOT NULL));
CREATE INDEX "IDX_cart_currency_code" ON public.cart USING btree (currency_code);
CREATE INDEX "IDX_cart_customer_id" ON public.cart USING btree (customer_id) WHERE ((deleted_at IS NULL) AND (customer_id IS NOT NULL));
CREATE INDEX "IDX_cart_deleted_at" ON public.cart USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);
CREATE INDEX "IDX_cart_region_id" ON public.cart USING btree (region_id) WHERE ((deleted_at IS NULL) AND (region_id IS NOT NULL));
CREATE INDEX "IDX_cart_sales_channel_id" ON public.cart USING btree (sales_channel_id) WHERE ((deleted_at IS NULL) AND (sales_channel_id IS NOT NULL));
CREATE INDEX "IDX_cart_shipping_address_id" ON public.cart USING btree (shipping_address_id) WHERE ((deleted_at IS NULL) AND (shipping_address_id IS NOT NULL));


-- public.cart_line_item definition

-- Drop table

-- DROP TABLE public.cart_line_item;

CREATE TABLE public.cart_line_item (
	id text NOT NULL,
	cart_id text NOT NULL,
	title text NOT NULL,
	subtitle text NULL,
	thumbnail text NULL,
	quantity int4 NOT NULL,
	variant_id text NULL,
	product_id text NULL,
	product_title text NULL,
	product_description text NULL,
	product_subtitle text NULL,
	product_type text NULL,
	product_collection text NULL,
	product_handle text NULL,
	variant_sku text NULL,
	variant_barcode text NULL,
	variant_title text NULL,
	variant_option_values jsonb NULL,
	requires_shipping bool DEFAULT true NOT NULL,
	is_discountable bool DEFAULT true NOT NULL,
	is_tax_inclusive bool DEFAULT false NOT NULL,
	compare_at_unit_price numeric NULL,
	raw_compare_at_unit_price jsonb NULL,
	unit_price numeric NOT NULL,
	raw_unit_price jsonb NOT NULL,
	metadata jsonb NULL,
	created_at timestamptz DEFAULT now() NOT NULL,
	updated_at timestamptz DEFAULT now() NOT NULL,
	deleted_at timestamptz NULL,
	product_type_id text NULL,
	is_custom_price bool DEFAULT false NOT NULL,
	CONSTRAINT cart_line_item_pkey PRIMARY KEY (id),
	CONSTRAINT cart_line_item_unit_price_check CHECK ((unit_price >= (0)::numeric)),
	CONSTRAINT cart_line_item_cart_id_foreign FOREIGN KEY (cart_id) REFERENCES public.cart(id) ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE INDEX "IDX_cart_line_item_cart_id" ON public.cart_line_item USING btree (cart_id) WHERE (deleted_at IS NULL);
CREATE INDEX "IDX_cart_line_item_deleted_at" ON public.cart_line_item USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);
CREATE INDEX "IDX_line_item_cart_id" ON public.cart_line_item USING btree (cart_id) WHERE (deleted_at IS NULL);
CREATE INDEX "IDX_line_item_product_id" ON public.cart_line_item USING btree (product_id) WHERE ((deleted_at IS NULL) AND (product_id IS NOT NULL));
CREATE INDEX "IDX_line_item_product_type_id" ON public.cart_line_item USING btree (product_type_id) WHERE ((deleted_at IS NULL) AND (product_type_id IS NOT NULL));
CREATE INDEX "IDX_line_item_variant_id" ON public.cart_line_item USING btree (variant_id) WHERE ((deleted_at IS NULL) AND (variant_id IS NOT NULL));


-- public.cart_line_item_adjustment definition

-- Drop table

-- DROP TABLE public.cart_line_item_adjustment;

CREATE TABLE public.cart_line_item_adjustment (
	id text NOT NULL,
	description text NULL,
	promotion_id text NULL,
	code text NULL,
	amount numeric NOT NULL,
	raw_amount jsonb NOT NULL,
	provider_id text NULL,
	metadata jsonb NULL,
	created_at timestamptz DEFAULT now() NOT NULL,
	updated_at timestamptz DEFAULT now() NOT NULL,
	deleted_at timestamptz NULL,
	item_id text NULL,
	CONSTRAINT cart_line_item_adjustment_check CHECK ((amount >= (0)::numeric)),
	CONSTRAINT cart_line_item_adjustment_pkey PRIMARY KEY (id),
	CONSTRAINT cart_line_item_adjustment_item_id_foreign FOREIGN KEY (item_id) REFERENCES public.cart_line_item(id) ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE INDEX "IDX_adjustment_item_id" ON public.cart_line_item_adjustment USING btree (item_id) WHERE (deleted_at IS NULL);
CREATE INDEX "IDX_cart_line_item_adjustment_deleted_at" ON public.cart_line_item_adjustment USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);
CREATE INDEX "IDX_cart_line_item_adjustment_item_id" ON public.cart_line_item_adjustment USING btree (item_id) WHERE (deleted_at IS NULL);
CREATE INDEX "IDX_line_item_adjustment_promotion_id" ON public.cart_line_item_adjustment USING btree (promotion_id) WHERE ((deleted_at IS NULL) AND (promotion_id IS NOT NULL));


-- public.cart_line_item_tax_line definition

-- Drop table

-- DROP TABLE public.cart_line_item_tax_line;

CREATE TABLE public.cart_line_item_tax_line (
	id text NOT NULL,
	description text NULL,
	tax_rate_id text NULL,
	code text NOT NULL,
	rate float4 NOT NULL,
	provider_id text NULL,
	metadata jsonb NULL,
	created_at timestamptz DEFAULT now() NOT NULL,
	updated_at timestamptz DEFAULT now() NOT NULL,
	deleted_at timestamptz NULL,
	item_id text NULL,
	CONSTRAINT cart_line_item_tax_line_pkey PRIMARY KEY (id),
	CONSTRAINT cart_line_item_tax_line_item_id_foreign FOREIGN KEY (item_id) REFERENCES public.cart_line_item(id) ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE INDEX "IDX_cart_line_item_tax_line_deleted_at" ON public.cart_line_item_tax_line USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);
CREATE INDEX "IDX_cart_line_item_tax_line_item_id" ON public.cart_line_item_tax_line USING btree (item_id) WHERE (deleted_at IS NULL);
CREATE INDEX "IDX_line_item_tax_line_tax_rate_id" ON public.cart_line_item_tax_line USING btree (tax_rate_id) WHERE ((deleted_at IS NULL) AND (tax_rate_id IS NOT NULL));
CREATE INDEX "IDX_tax_line_item_id" ON public.cart_line_item_tax_line USING btree (item_id) WHERE (deleted_at IS NULL);


-- public.cart_shipping_method definition

-- Drop table

-- DROP TABLE public.cart_shipping_method;

CREATE TABLE public.cart_shipping_method (
	id text NOT NULL,
	cart_id text NOT NULL,
	"name" text NOT NULL,
	description jsonb NULL,
	amount numeric NOT NULL,
	raw_amount jsonb NOT NULL,
	is_tax_inclusive bool DEFAULT false NOT NULL,
	shipping_option_id text NULL,
	"data" jsonb NULL,
	metadata jsonb NULL,
	created_at timestamptz DEFAULT now() NOT NULL,
	updated_at timestamptz DEFAULT now() NOT NULL,
	deleted_at timestamptz NULL,
	CONSTRAINT cart_shipping_method_check CHECK ((amount >= (0)::numeric)),
	CONSTRAINT cart_shipping_method_pkey PRIMARY KEY (id),
	CONSTRAINT cart_shipping_method_cart_id_foreign FOREIGN KEY (cart_id) REFERENCES public.cart(id) ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE INDEX "IDX_cart_shipping_method_cart_id" ON public.cart_shipping_method USING btree (cart_id) WHERE (deleted_at IS NULL);
CREATE INDEX "IDX_cart_shipping_method_deleted_at" ON public.cart_shipping_method USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);
CREATE INDEX "IDX_shipping_method_cart_id" ON public.cart_shipping_method USING btree (cart_id) WHERE (deleted_at IS NULL);
CREATE INDEX "IDX_shipping_method_option_id" ON public.cart_shipping_method USING btree (shipping_option_id) WHERE ((deleted_at IS NULL) AND (shipping_option_id IS NOT NULL));


-- public.cart_shipping_method_adjustment definition

-- Drop table

-- DROP TABLE public.cart_shipping_method_adjustment;

CREATE TABLE public.cart_shipping_method_adjustment (
	id text NOT NULL,
	description text NULL,
	promotion_id text NULL,
	code text NULL,
	amount numeric NOT NULL,
	raw_amount jsonb NOT NULL,
	provider_id text NULL,
	metadata jsonb NULL,
	created_at timestamptz DEFAULT now() NOT NULL,
	updated_at timestamptz DEFAULT now() NOT NULL,
	deleted_at timestamptz NULL,
	shipping_method_id text NULL,
	CONSTRAINT cart_shipping_method_adjustment_pkey PRIMARY KEY (id),
	CONSTRAINT cart_shipping_method_adjustment_shipping_method_id_foreign FOREIGN KEY (shipping_method_id) REFERENCES public.cart_shipping_method(id) ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE INDEX "IDX_adjustment_shipping_method_id" ON public.cart_shipping_method_adjustment USING btree (shipping_method_id) WHERE (deleted_at IS NULL);
CREATE INDEX "IDX_cart_shipping_method_adjustment_deleted_at" ON public.cart_shipping_method_adjustment USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);
CREATE INDEX "IDX_cart_shipping_method_adjustment_shipping_method_id" ON public.cart_shipping_method_adjustment USING btree (shipping_method_id) WHERE (deleted_at IS NULL);
CREATE INDEX "IDX_shipping_method_adjustment_promotion_id" ON public.cart_shipping_method_adjustment USING btree (promotion_id) WHERE ((deleted_at IS NULL) AND (promotion_id IS NOT NULL));


-- public.cart_shipping_method_tax_line definition

-- Drop table

-- DROP TABLE public.cart_shipping_method_tax_line;

CREATE TABLE public.cart_shipping_method_tax_line (
	id text NOT NULL,
	description text NULL,
	tax_rate_id text NULL,
	code text NOT NULL,
	rate float4 NOT NULL,
	provider_id text NULL,
	metadata jsonb NULL,
	created_at timestamptz DEFAULT now() NOT NULL,
	updated_at timestamptz DEFAULT now() NOT NULL,
	deleted_at timestamptz NULL,
	shipping_method_id text NULL,
	CONSTRAINT cart_shipping_method_tax_line_pkey PRIMARY KEY (id),
	CONSTRAINT cart_shipping_method_tax_line_shipping_method_id_foreign FOREIGN KEY (shipping_method_id) REFERENCES public.cart_shipping_method(id) ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE INDEX "IDX_cart_shipping_method_tax_line_deleted_at" ON public.cart_shipping_method_tax_line USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);
CREATE INDEX "IDX_cart_shipping_method_tax_line_shipping_method_id" ON public.cart_shipping_method_tax_line USING btree (shipping_method_id) WHERE (deleted_at IS NULL);
CREATE INDEX "IDX_shipping_method_tax_line_tax_rate_id" ON public.cart_shipping_method_tax_line USING btree (tax_rate_id) WHERE ((deleted_at IS NULL) AND (tax_rate_id IS NOT NULL));
CREATE INDEX "IDX_tax_line_shipping_method_id" ON public.cart_shipping_method_tax_line USING btree (shipping_method_id) WHERE (deleted_at IS NULL);


-- public.customer_address definition

-- Drop table

-- DROP TABLE public.customer_address;

CREATE TABLE public.customer_address (
	id text NOT NULL,
	customer_id text NOT NULL,
	address_name text NULL,
	is_default_shipping bool DEFAULT false NOT NULL,
	is_default_billing bool DEFAULT false NOT NULL,
	company text NULL,
	first_name text NULL,
	last_name text NULL,
	address_1 text NULL,
	address_2 text NULL,
	city text NULL,
	country_code text NULL,
	province text NULL,
	postal_code text NULL,
	phone text NULL,
	metadata jsonb NULL,
	created_at timestamptz DEFAULT now() NOT NULL,
	updated_at timestamptz DEFAULT now() NOT NULL,
	deleted_at timestamptz NULL,
	CONSTRAINT customer_address_pkey PRIMARY KEY (id),
	CONSTRAINT customer_address_customer_id_foreign FOREIGN KEY (customer_id) REFERENCES public.customer(id) ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE INDEX "IDX_customer_address_customer_id" ON public.customer_address USING btree (customer_id);
CREATE INDEX "IDX_customer_address_deleted_at" ON public.customer_address USING btree (deleted_at) WHERE (deleted_at IS NULL);
CREATE UNIQUE INDEX "IDX_customer_address_unique_customer_billing" ON public.customer_address USING btree (customer_id) WHERE (is_default_billing = true);
CREATE UNIQUE INDEX "IDX_customer_address_unique_customer_shipping" ON public.customer_address USING btree (customer_id) WHERE (is_default_shipping = true);


-- public.customer_group_customer definition

-- Drop table

-- DROP TABLE public.customer_group_customer;

CREATE TABLE public.customer_group_customer (
	id text NOT NULL,
	customer_id text NOT NULL,
	customer_group_id text NOT NULL,
	metadata jsonb NULL,
	created_at timestamptz DEFAULT now() NOT NULL,
	updated_at timestamptz DEFAULT now() NOT NULL,
	created_by text NULL,
	deleted_at timestamptz NULL,
	CONSTRAINT customer_group_customer_pkey PRIMARY KEY (id),
	CONSTRAINT customer_group_customer_customer_group_id_foreign FOREIGN KEY (customer_group_id) REFERENCES public.customer_group(id) ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT customer_group_customer_customer_id_foreign FOREIGN KEY (customer_id) REFERENCES public.customer(id) ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE INDEX "IDX_customer_group_customer_customer_group_id" ON public.customer_group_customer USING btree (customer_group_id) WHERE (deleted_at IS NULL);
CREATE INDEX "IDX_customer_group_customer_customer_id" ON public.customer_group_customer USING btree (customer_id);
CREATE INDEX "IDX_customer_group_customer_deleted_at" ON public.customer_group_customer USING btree (deleted_at) WHERE (deleted_at IS NULL);


-- public.inventory_level definition

-- Drop table

-- DROP TABLE public.inventory_level;

CREATE TABLE public.inventory_level (
	id text NOT NULL,
	created_at timestamptz DEFAULT now() NOT NULL,
	updated_at timestamptz DEFAULT now() NOT NULL,
	deleted_at timestamptz NULL,
	inventory_item_id text NOT NULL,
	location_id text NOT NULL,
	stocked_quantity numeric DEFAULT 0 NOT NULL,
	reserved_quantity numeric DEFAULT 0 NOT NULL,
	incoming_quantity numeric DEFAULT 0 NOT NULL,
	metadata jsonb NULL,
	raw_stocked_quantity jsonb NULL,
	raw_reserved_quantity jsonb NULL,
	raw_incoming_quantity jsonb NULL,
	CONSTRAINT inventory_level_pkey PRIMARY KEY (id),
	CONSTRAINT inventory_level_inventory_item_id_foreign FOREIGN KEY (inventory_item_id) REFERENCES public.inventory_item(id) ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE INDEX "IDX_inventory_level_deleted_at" ON public.inventory_level USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);
CREATE INDEX "IDX_inventory_level_inventory_item_id" ON public.inventory_level USING btree (inventory_item_id) WHERE (deleted_at IS NULL);
CREATE UNIQUE INDEX "IDX_inventory_level_item_location" ON public.inventory_level USING btree (inventory_item_id, location_id) WHERE (deleted_at IS NULL);
CREATE INDEX "IDX_inventory_level_location_id" ON public.inventory_level USING btree (location_id) WHERE (deleted_at IS NULL);
CREATE UNIQUE INDEX "IDX_inventory_level_location_id_inventory_item_id" ON public.inventory_level USING btree (inventory_item_id, location_id) WHERE (deleted_at IS NULL);


-- public.notification definition

-- Drop table

-- DROP TABLE public.notification;

CREATE TABLE public.notification (
	id text NOT NULL,
	"to" text NOT NULL,
	channel text NOT NULL,
	"template" text NOT NULL,
	"data" jsonb NULL,
	trigger_type text NULL,
	resource_id text NULL,
	resource_type text NULL,
	receiver_id text NULL,
	original_notification_id text NULL,
	idempotency_key text NULL,
	external_id text NULL,
	provider_id text NULL,
	created_at timestamptz DEFAULT now() NOT NULL,
	updated_at timestamptz DEFAULT now() NOT NULL,
	deleted_at timestamptz NULL,
	status text DEFAULT 'pending'::text NOT NULL,
	CONSTRAINT notification_pkey PRIMARY KEY (id),
	CONSTRAINT notification_status_check CHECK ((status = ANY (ARRAY['pending'::text, 'success'::text, 'failure'::text]))),
	CONSTRAINT notification_provider_id_foreign FOREIGN KEY (provider_id) REFERENCES public.notification_provider(id) ON DELETE SET NULL ON UPDATE CASCADE
);
CREATE UNIQUE INDEX "IDX_notification_idempotency_key_unique" ON public.notification USING btree (idempotency_key) WHERE (deleted_at IS NULL);
CREATE INDEX "IDX_notification_provider_id" ON public.notification USING btree (provider_id);
CREATE INDEX "IDX_notification_receiver_id" ON public.notification USING btree (receiver_id);


-- public."order" definition

-- Drop table

-- DROP TABLE public."order";

CREATE TABLE public."order" (
	id text NOT NULL,
	region_id text NULL,
	display_id serial4 NULL,
	customer_id text NULL,
	"version" int4 DEFAULT 1 NOT NULL,
	sales_channel_id text NULL,
	status public.order_status_enum DEFAULT 'pending'::order_status_enum NOT NULL,
	is_draft_order bool DEFAULT false NOT NULL,
	email text NULL,
	currency_code text NOT NULL,
	shipping_address_id text NULL,
	billing_address_id text NULL,
	no_notification bool NULL,
	metadata jsonb NULL,
	created_at timestamptz DEFAULT now() NOT NULL,
	updated_at timestamptz DEFAULT now() NOT NULL,
	deleted_at timestamptz NULL,
	canceled_at timestamptz NULL,
	CONSTRAINT order_pkey PRIMARY KEY (id),
	CONSTRAINT order_billing_address_id_foreign FOREIGN KEY (billing_address_id) REFERENCES public.order_address(id) ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT order_shipping_address_id_foreign FOREIGN KEY (shipping_address_id) REFERENCES public.order_address(id) ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE INDEX "IDX_order_billing_address_id" ON public."order" USING btree (billing_address_id) WHERE (deleted_at IS NULL);
CREATE INDEX "IDX_order_currency_code" ON public."order" USING btree (currency_code) WHERE (deleted_at IS NULL);
CREATE INDEX "IDX_order_customer_id" ON public."order" USING btree (customer_id) WHERE (deleted_at IS NULL);
CREATE INDEX "IDX_order_deleted_at" ON public."order" USING btree (deleted_at);
CREATE INDEX "IDX_order_display_id" ON public."order" USING btree (display_id) WHERE (deleted_at IS NULL);
CREATE INDEX "IDX_order_is_draft_order" ON public."order" USING btree (is_draft_order) WHERE (deleted_at IS NULL);
CREATE INDEX "IDX_order_region_id" ON public."order" USING btree (region_id) WHERE (deleted_at IS NULL);
CREATE INDEX "IDX_order_shipping_address_id" ON public."order" USING btree (shipping_address_id) WHERE (deleted_at IS NULL);


-- public.order_change definition

-- Drop table

-- DROP TABLE public.order_change;

CREATE TABLE public.order_change (
	id text NOT NULL,
	order_id text NOT NULL,
	"version" int4 NOT NULL,
	description text NULL,
	status text DEFAULT 'pending'::text NOT NULL,
	internal_note text NULL,
	created_by text NULL,
	requested_by text NULL,
	requested_at timestamptz NULL,
	confirmed_by text NULL,
	confirmed_at timestamptz NULL,
	declined_by text NULL,
	declined_reason text NULL,
	metadata jsonb NULL,
	declined_at timestamptz NULL,
	canceled_by text NULL,
	canceled_at timestamptz NULL,
	created_at timestamptz DEFAULT now() NOT NULL,
	updated_at timestamptz DEFAULT now() NOT NULL,
	change_type text NULL,
	deleted_at timestamptz NULL,
	return_id text NULL,
	claim_id text NULL,
	exchange_id text NULL,
	CONSTRAINT order_change_pkey PRIMARY KEY (id),
	CONSTRAINT order_change_status_check CHECK ((status = ANY (ARRAY['confirmed'::text, 'declined'::text, 'requested'::text, 'pending'::text, 'canceled'::text]))),
	CONSTRAINT order_change_order_id_foreign FOREIGN KEY (order_id) REFERENCES public."order"(id) ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE INDEX "IDX_order_change_change_type" ON public.order_change USING btree (change_type);
CREATE INDEX "IDX_order_change_claim_id" ON public.order_change USING btree (claim_id) WHERE ((claim_id IS NOT NULL) AND (deleted_at IS NULL));
CREATE INDEX "IDX_order_change_deleted_at" ON public.order_change USING btree (deleted_at);
CREATE INDEX "IDX_order_change_exchange_id" ON public.order_change USING btree (exchange_id) WHERE ((exchange_id IS NOT NULL) AND (deleted_at IS NULL));
CREATE INDEX "IDX_order_change_order_id" ON public.order_change USING btree (order_id);
CREATE INDEX "IDX_order_change_order_id_version" ON public.order_change USING btree (order_id, version);
CREATE INDEX "IDX_order_change_return_id" ON public.order_change USING btree (return_id) WHERE ((return_id IS NOT NULL) AND (deleted_at IS NULL));
CREATE INDEX "IDX_order_change_status" ON public.order_change USING btree (status);


-- public.order_change_action definition

-- Drop table

-- DROP TABLE public.order_change_action;

CREATE TABLE public.order_change_action (
	id text NOT NULL,
	order_id text NULL,
	"version" int4 NULL,
	"ordering" bigserial NOT NULL,
	order_change_id text NULL,
	reference text NULL,
	reference_id text NULL,
	"action" text NOT NULL,
	details jsonb NULL,
	amount numeric NULL,
	raw_amount jsonb NULL,
	internal_note text NULL,
	applied bool DEFAULT false NOT NULL,
	created_at timestamptz DEFAULT now() NOT NULL,
	updated_at timestamptz DEFAULT now() NOT NULL,
	deleted_at timestamptz NULL,
	return_id text NULL,
	claim_id text NULL,
	exchange_id text NULL,
	CONSTRAINT order_change_action_pkey PRIMARY KEY (id),
	CONSTRAINT order_change_action_order_change_id_foreign FOREIGN KEY (order_change_id) REFERENCES public.order_change(id) ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE INDEX "IDX_order_change_action_claim_id" ON public.order_change_action USING btree (claim_id) WHERE ((claim_id IS NOT NULL) AND (deleted_at IS NULL));
CREATE INDEX "IDX_order_change_action_deleted_at" ON public.order_change_action USING btree (deleted_at);
CREATE INDEX "IDX_order_change_action_exchange_id" ON public.order_change_action USING btree (exchange_id) WHERE ((exchange_id IS NOT NULL) AND (deleted_at IS NULL));
CREATE INDEX "IDX_order_change_action_order_change_id" ON public.order_change_action USING btree (order_change_id);
CREATE INDEX "IDX_order_change_action_order_id" ON public.order_change_action USING btree (order_id);
CREATE INDEX "IDX_order_change_action_ordering" ON public.order_change_action USING btree (ordering);
CREATE INDEX "IDX_order_change_action_return_id" ON public.order_change_action USING btree (return_id) WHERE ((return_id IS NOT NULL) AND (deleted_at IS NULL));


-- public.order_credit_line definition

-- Drop table

-- DROP TABLE public.order_credit_line;

CREATE TABLE public.order_credit_line (
	id text NOT NULL,
	order_id text NOT NULL,
	reference text NULL,
	reference_id text NULL,
	amount numeric NOT NULL,
	raw_amount jsonb NOT NULL,
	metadata jsonb NULL,
	created_at timestamptz DEFAULT now() NOT NULL,
	updated_at timestamptz DEFAULT now() NOT NULL,
	deleted_at timestamptz NULL,
	CONSTRAINT order_credit_line_pkey PRIMARY KEY (id),
	CONSTRAINT order_credit_line_order_id_foreign FOREIGN KEY (order_id) REFERENCES public."order"(id) ON UPDATE CASCADE
);
CREATE INDEX "IDX_order_credit_line_deleted_at" ON public.order_credit_line USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);
CREATE INDEX "IDX_order_credit_line_order_id" ON public.order_credit_line USING btree (order_id) WHERE (deleted_at IS NOT NULL);


-- public.order_shipping definition

-- Drop table

-- DROP TABLE public.order_shipping;

CREATE TABLE public.order_shipping (
	id text NOT NULL,
	order_id text NOT NULL,
	"version" int4 NOT NULL,
	shipping_method_id text NOT NULL,
	created_at timestamptz DEFAULT now() NOT NULL,
	updated_at timestamptz DEFAULT now() NOT NULL,
	deleted_at timestamptz NULL,
	return_id text NULL,
	claim_id text NULL,
	exchange_id text NULL,
	CONSTRAINT order_shipping_pkey PRIMARY KEY (id),
	CONSTRAINT order_shipping_order_id_foreign FOREIGN KEY (order_id) REFERENCES public."order"(id) ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE INDEX "IDX_order_shipping_claim_id" ON public.order_shipping USING btree (claim_id) WHERE ((claim_id IS NOT NULL) AND (deleted_at IS NULL));
CREATE INDEX "IDX_order_shipping_deleted_at" ON public.order_shipping USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);
CREATE INDEX "IDX_order_shipping_exchange_id" ON public.order_shipping USING btree (exchange_id) WHERE ((exchange_id IS NOT NULL) AND (deleted_at IS NULL));
CREATE INDEX "IDX_order_shipping_item_id" ON public.order_shipping USING btree (shipping_method_id) WHERE (deleted_at IS NULL);
CREATE INDEX "IDX_order_shipping_order_id" ON public.order_shipping USING btree (order_id) WHERE (deleted_at IS NULL);
CREATE INDEX "IDX_order_shipping_order_id_version" ON public.order_shipping USING btree (order_id, version) WHERE (deleted_at IS NULL);
CREATE INDEX "IDX_order_shipping_return_id" ON public.order_shipping USING btree (return_id) WHERE ((return_id IS NOT NULL) AND (deleted_at IS NULL));


-- public.order_shipping_method_adjustment definition

-- Drop table

-- DROP TABLE public.order_shipping_method_adjustment;

CREATE TABLE public.order_shipping_method_adjustment (
	id text NOT NULL,
	description text NULL,
	promotion_id text NULL,
	code text NULL,
	amount numeric NOT NULL,
	raw_amount jsonb NOT NULL,
	provider_id text NULL,
	created_at timestamptz DEFAULT now() NOT NULL,
	updated_at timestamptz DEFAULT now() NOT NULL,
	shipping_method_id text NOT NULL,
	deleted_at timestamptz NULL,
	CONSTRAINT order_shipping_method_adjustment_pkey PRIMARY KEY (id),
	CONSTRAINT order_shipping_method_adjustment_shipping_method_id_foreign FOREIGN KEY (shipping_method_id) REFERENCES public.order_shipping_method(id) ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE INDEX "IDX_order_shipping_method_adjustment_shipping_method_id" ON public.order_shipping_method_adjustment USING btree (shipping_method_id) WHERE (deleted_at IS NULL);


-- public.order_shipping_method_tax_line definition

-- Drop table

-- DROP TABLE public.order_shipping_method_tax_line;

CREATE TABLE public.order_shipping_method_tax_line (
	id text NOT NULL,
	description text NULL,
	tax_rate_id text NULL,
	code text NOT NULL,
	rate numeric NOT NULL,
	raw_rate jsonb NOT NULL,
	provider_id text NULL,
	created_at timestamptz DEFAULT now() NOT NULL,
	updated_at timestamptz DEFAULT now() NOT NULL,
	shipping_method_id text NOT NULL,
	deleted_at timestamptz NULL,
	CONSTRAINT order_shipping_method_tax_line_pkey PRIMARY KEY (id),
	CONSTRAINT order_shipping_method_tax_line_shipping_method_id_foreign FOREIGN KEY (shipping_method_id) REFERENCES public.order_shipping_method(id) ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE INDEX "IDX_order_shipping_method_tax_line_shipping_method_id" ON public.order_shipping_method_tax_line USING btree (shipping_method_id) WHERE (deleted_at IS NULL);


-- public.order_transaction definition

-- Drop table

-- DROP TABLE public.order_transaction;

CREATE TABLE public.order_transaction (
	id text NOT NULL,
	order_id text NOT NULL,
	"version" int4 DEFAULT 1 NOT NULL,
	amount numeric NOT NULL,
	raw_amount jsonb NOT NULL,
	currency_code text NOT NULL,
	reference text NULL,
	reference_id text NULL,
	created_at timestamptz DEFAULT now() NOT NULL,
	updated_at timestamptz DEFAULT now() NOT NULL,
	deleted_at timestamptz NULL,
	return_id text NULL,
	claim_id text NULL,
	exchange_id text NULL,
	CONSTRAINT order_transaction_pkey PRIMARY KEY (id),
	CONSTRAINT order_transaction_order_id_foreign FOREIGN KEY (order_id) REFERENCES public."order"(id) ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE INDEX "IDX_order_transaction_claim_id" ON public.order_transaction USING btree (claim_id) WHERE ((claim_id IS NOT NULL) AND (deleted_at IS NULL));
CREATE INDEX "IDX_order_transaction_currency_code" ON public.order_transaction USING btree (currency_code) WHERE (deleted_at IS NULL);
CREATE INDEX "IDX_order_transaction_exchange_id" ON public.order_transaction USING btree (exchange_id) WHERE ((exchange_id IS NOT NULL) AND (deleted_at IS NULL));
CREATE INDEX "IDX_order_transaction_order_id_version" ON public.order_transaction USING btree (order_id, version) WHERE (deleted_at IS NULL);
CREATE INDEX "IDX_order_transaction_reference_id" ON public.order_transaction USING btree (reference_id) WHERE (deleted_at IS NULL);
CREATE INDEX "IDX_order_transaction_return_id" ON public.order_transaction USING btree (return_id) WHERE ((return_id IS NOT NULL) AND (deleted_at IS NULL));


-- public.payment definition

-- Drop table

-- DROP TABLE public.payment;

CREATE TABLE public.payment (
	id text NOT NULL,
	amount numeric NOT NULL,
	raw_amount jsonb NOT NULL,
	currency_code text NOT NULL,
	provider_id text NOT NULL,
	cart_id text NULL,
	order_id text NULL,
	customer_id text NULL,
	"data" jsonb NULL,
	created_at timestamptz DEFAULT now() NOT NULL,
	updated_at timestamptz DEFAULT now() NOT NULL,
	deleted_at timestamptz NULL,
	captured_at timestamptz NULL,
	canceled_at timestamptz NULL,
	payment_collection_id text NOT NULL,
	payment_session_id text NOT NULL,
	metadata jsonb NULL,
	CONSTRAINT payment_payment_session_id_unique UNIQUE (payment_session_id),
	CONSTRAINT payment_pkey PRIMARY KEY (id),
	CONSTRAINT payment_payment_collection_id_foreign FOREIGN KEY (payment_collection_id) REFERENCES public.payment_collection(id) ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE INDEX "IDX_payment_deleted_at" ON public.payment USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);
CREATE INDEX "IDX_payment_payment_collection_id" ON public.payment USING btree (payment_collection_id) WHERE (deleted_at IS NULL);
CREATE INDEX "IDX_payment_payment_session_id" ON public.payment USING btree (payment_session_id);
CREATE INDEX "IDX_payment_provider_id" ON public.payment USING btree (provider_id) WHERE (deleted_at IS NULL);


-- public.payment_collection_payment_providers definition

-- Drop table

-- DROP TABLE public.payment_collection_payment_providers;

CREATE TABLE public.payment_collection_payment_providers (
	payment_collection_id text NOT NULL,
	payment_provider_id text NOT NULL,
	CONSTRAINT payment_collection_payment_providers_pkey PRIMARY KEY (payment_collection_id, payment_provider_id),
	CONSTRAINT payment_collection_payment_providers_payment_coll_aa276_foreign FOREIGN KEY (payment_collection_id) REFERENCES public.payment_collection(id) ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT payment_collection_payment_providers_payment_provider_id_foreig FOREIGN KEY (payment_provider_id) REFERENCES public.payment_provider(id) ON DELETE CASCADE ON UPDATE CASCADE
);


-- public.payment_session definition

-- Drop table

-- DROP TABLE public.payment_session;

CREATE TABLE public.payment_session (
	id text NOT NULL,
	currency_code text NOT NULL,
	amount numeric NOT NULL,
	raw_amount jsonb NOT NULL,
	provider_id text NOT NULL,
	"data" jsonb DEFAULT '{}'::jsonb NOT NULL,
	context jsonb NULL,
	status text DEFAULT 'pending'::text NOT NULL,
	authorized_at timestamptz NULL,
	payment_collection_id text NOT NULL,
	metadata jsonb NULL,
	created_at timestamptz DEFAULT now() NOT NULL,
	updated_at timestamptz DEFAULT now() NOT NULL,
	deleted_at timestamptz NULL,
	CONSTRAINT payment_session_pkey PRIMARY KEY (id),
	CONSTRAINT payment_session_status_check CHECK ((status = ANY (ARRAY['authorized'::text, 'captured'::text, 'pending'::text, 'requires_more'::text, 'error'::text, 'canceled'::text]))),
	CONSTRAINT payment_session_payment_collection_id_foreign FOREIGN KEY (payment_collection_id) REFERENCES public.payment_collection(id) ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE INDEX "IDX_payment_session_deleted_at" ON public.payment_session USING btree (deleted_at);
CREATE INDEX "IDX_payment_session_payment_collection_id" ON public.payment_session USING btree (payment_collection_id) WHERE (deleted_at IS NULL);


-- public.price definition

-- Drop table

-- DROP TABLE public.price;

CREATE TABLE public.price (
	id text NOT NULL,
	title text NULL,
	price_set_id text NOT NULL,
	currency_code text NOT NULL,
	raw_amount jsonb NOT NULL,
	rules_count int4 DEFAULT 0 NULL,
	created_at timestamptz DEFAULT now() NOT NULL,
	updated_at timestamptz DEFAULT now() NOT NULL,
	deleted_at timestamptz NULL,
	price_list_id text NULL,
	amount numeric NOT NULL,
	min_quantity int4 NULL,
	max_quantity int4 NULL,
	CONSTRAINT price_pkey PRIMARY KEY (id),
	CONSTRAINT price_price_list_id_foreign FOREIGN KEY (price_list_id) REFERENCES public.price_list(id) ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT price_price_set_id_foreign FOREIGN KEY (price_set_id) REFERENCES public.price_set(id) ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE INDEX "IDX_price_currency_code" ON public.price USING btree (currency_code) WHERE (deleted_at IS NULL);
CREATE INDEX "IDX_price_deleted_at" ON public.price USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);
CREATE INDEX "IDX_price_price_list_id" ON public.price USING btree (price_list_id) WHERE (deleted_at IS NULL);
CREATE INDEX "IDX_price_price_set_id" ON public.price USING btree (price_set_id) WHERE (deleted_at IS NULL);


-- public.price_list_rule definition

-- Drop table

-- DROP TABLE public.price_list_rule;

CREATE TABLE public.price_list_rule (
	id text NOT NULL,
	price_list_id text NOT NULL,
	created_at timestamptz DEFAULT now() NOT NULL,
	updated_at timestamptz DEFAULT now() NOT NULL,
	deleted_at timestamptz NULL,
	value jsonb NULL,
	"attribute" text DEFAULT ''::text NOT NULL,
	CONSTRAINT price_list_rule_pkey PRIMARY KEY (id),
	CONSTRAINT price_list_rule_price_list_id_foreign FOREIGN KEY (price_list_id) REFERENCES public.price_list(id) ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE INDEX "IDX_price_list_rule_deleted_at" ON public.price_list_rule USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);
CREATE INDEX "IDX_price_list_rule_price_list_id" ON public.price_list_rule USING btree (price_list_id) WHERE (deleted_at IS NOT NULL);


-- public.price_rule definition

-- Drop table

-- DROP TABLE public.price_rule;

CREATE TABLE public.price_rule (
	id text NOT NULL,
	value text NOT NULL,
	priority int4 DEFAULT 0 NOT NULL,
	price_id text NOT NULL,
	created_at timestamptz DEFAULT now() NOT NULL,
	updated_at timestamptz DEFAULT now() NOT NULL,
	deleted_at timestamptz NULL,
	"attribute" text DEFAULT ''::text NOT NULL,
	"operator" text DEFAULT 'eq'::text NOT NULL,
	CONSTRAINT price_rule_operator_check CHECK ((operator = ANY (ARRAY['gte'::text, 'lte'::text, 'gt'::text, 'lt'::text, 'eq'::text]))),
	CONSTRAINT price_rule_pkey PRIMARY KEY (id),
	CONSTRAINT price_rule_price_id_foreign FOREIGN KEY (price_id) REFERENCES public.price(id) ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE INDEX "IDX_price_rule_deleted_at" ON public.price_rule USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);
CREATE INDEX "IDX_price_rule_operator" ON public.price_rule USING btree (operator);
CREATE INDEX "IDX_price_rule_price_id" ON public.price_rule USING btree (price_id) WHERE (deleted_at IS NULL);
CREATE UNIQUE INDEX "IDX_price_rule_price_id_attribute_operator_unique" ON public.price_rule USING btree (price_id, attribute, operator) WHERE (deleted_at IS NULL);


-- public.product definition

-- Drop table

-- DROP TABLE public.product;

CREATE TABLE public.product (
	id text NOT NULL,
	title text NOT NULL,
	handle text NOT NULL,
	subtitle text NULL,
	description text NULL,
	is_giftcard bool DEFAULT false NOT NULL,
	status text DEFAULT 'draft'::text NOT NULL,
	thumbnail text NULL,
	weight text NULL,
	length text NULL,
	height text NULL,
	width text NULL,
	origin_country text NULL,
	hs_code text NULL,
	mid_code text NULL,
	material text NULL,
	collection_id text NULL,
	type_id text NULL,
	discountable bool DEFAULT true NOT NULL,
	external_id text NULL,
	created_at timestamptz DEFAULT now() NOT NULL,
	updated_at timestamptz DEFAULT now() NOT NULL,
	deleted_at timestamptz NULL,
	metadata jsonb NULL,
	CONSTRAINT product_pkey PRIMARY KEY (id),
	CONSTRAINT product_status_check CHECK ((status = ANY (ARRAY['draft'::text, 'proposed'::text, 'published'::text, 'rejected'::text]))),
	CONSTRAINT product_collection_id_foreign FOREIGN KEY (collection_id) REFERENCES public.product_collection(id) ON DELETE SET NULL ON UPDATE CASCADE,
	CONSTRAINT product_type_id_foreign FOREIGN KEY (type_id) REFERENCES public.product_type(id) ON DELETE SET NULL ON UPDATE CASCADE
);
CREATE INDEX "IDX_product_collection_id" ON public.product USING btree (collection_id) WHERE (deleted_at IS NULL);
CREATE INDEX "IDX_product_deleted_at" ON public.product USING btree (deleted_at);
CREATE UNIQUE INDEX "IDX_product_handle_unique" ON public.product USING btree (handle) WHERE (deleted_at IS NULL);
CREATE INDEX "IDX_product_type_id" ON public.product USING btree (type_id) WHERE (deleted_at IS NULL);


-- public.product_category definition

-- Drop table

-- DROP TABLE public.product_category;

CREATE TABLE public.product_category (
	id text NOT NULL,
	"name" text NOT NULL,
	description text DEFAULT ''::text NOT NULL,
	handle text NOT NULL,
	mpath text NOT NULL,
	is_active bool DEFAULT false NOT NULL,
	is_internal bool DEFAULT false NOT NULL,
	"rank" int4 DEFAULT 0 NOT NULL,
	parent_category_id text NULL,
	created_at timestamptz DEFAULT now() NOT NULL,
	updated_at timestamptz DEFAULT now() NOT NULL,
	deleted_at timestamptz NULL,
	metadata jsonb NULL,
	CONSTRAINT product_category_pkey PRIMARY KEY (id),
	CONSTRAINT product_category_parent_category_id_foreign FOREIGN KEY (parent_category_id) REFERENCES public.product_category(id) ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE UNIQUE INDEX "IDX_category_handle_unique" ON public.product_category USING btree (handle) WHERE (deleted_at IS NULL);
CREATE INDEX "IDX_product_category_parent_category_id" ON public.product_category USING btree (parent_category_id) WHERE (deleted_at IS NULL);
CREATE INDEX "IDX_product_category_path" ON public.product_category USING btree (mpath) WHERE (deleted_at IS NULL);


-- public.product_category_product definition

-- Drop table

-- DROP TABLE public.product_category_product;

CREATE TABLE public.product_category_product (
	product_id text NOT NULL,
	product_category_id text NOT NULL,
	CONSTRAINT product_category_product_pkey PRIMARY KEY (product_id, product_category_id),
	CONSTRAINT product_category_product_product_category_id_foreign FOREIGN KEY (product_category_id) REFERENCES public.product_category(id) ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT product_category_product_product_id_foreign FOREIGN KEY (product_id) REFERENCES public.product(id) ON DELETE CASCADE ON UPDATE CASCADE
);


-- public.product_option definition

-- Drop table

-- DROP TABLE public.product_option;

CREATE TABLE public.product_option (
	id text NOT NULL,
	title text NOT NULL,
	product_id text NOT NULL,
	metadata jsonb NULL,
	created_at timestamptz DEFAULT now() NOT NULL,
	updated_at timestamptz DEFAULT now() NOT NULL,
	deleted_at timestamptz NULL,
	CONSTRAINT product_option_pkey PRIMARY KEY (id),
	CONSTRAINT product_option_product_id_foreign FOREIGN KEY (product_id) REFERENCES public.product(id) ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE UNIQUE INDEX "IDX_option_product_id_title_unique" ON public.product_option USING btree (product_id, title) WHERE (deleted_at IS NULL);
CREATE INDEX "IDX_product_option_deleted_at" ON public.product_option USING btree (deleted_at);
CREATE INDEX "IDX_product_option_product_id" ON public.product_option USING btree (product_id) WHERE (deleted_at IS NULL);


-- public.product_option_value definition

-- Drop table

-- DROP TABLE public.product_option_value;

CREATE TABLE public.product_option_value (
	id text NOT NULL,
	value text NOT NULL,
	option_id text NULL,
	metadata jsonb NULL,
	created_at timestamptz DEFAULT now() NOT NULL,
	updated_at timestamptz DEFAULT now() NOT NULL,
	deleted_at timestamptz NULL,
	CONSTRAINT product_option_value_pkey PRIMARY KEY (id),
	CONSTRAINT product_option_value_option_id_foreign FOREIGN KEY (option_id) REFERENCES public.product_option(id) ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE UNIQUE INDEX "IDX_option_value_option_id_unique" ON public.product_option_value USING btree (option_id, value) WHERE (deleted_at IS NULL);
CREATE INDEX "IDX_product_option_value_deleted_at" ON public.product_option_value USING btree (deleted_at);
CREATE INDEX "IDX_product_option_value_option_id" ON public.product_option_value USING btree (option_id) WHERE (deleted_at IS NULL);


-- public.product_tags definition

-- Drop table

-- DROP TABLE public.product_tags;

CREATE TABLE public.product_tags (
	product_id text NOT NULL,
	product_tag_id text NOT NULL,
	CONSTRAINT product_tags_pkey PRIMARY KEY (product_id, product_tag_id),
	CONSTRAINT product_tags_product_id_foreign FOREIGN KEY (product_id) REFERENCES public.product(id) ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT product_tags_product_tag_id_foreign FOREIGN KEY (product_tag_id) REFERENCES public.product_tag(id) ON DELETE CASCADE ON UPDATE CASCADE
);


-- public.product_variant definition

-- Drop table

-- DROP TABLE public.product_variant;

CREATE TABLE public.product_variant (
	id text NOT NULL,
	title text NOT NULL,
	sku text NULL,
	barcode text NULL,
	ean text NULL,
	upc text NULL,
	allow_backorder bool DEFAULT false NOT NULL,
	manage_inventory bool DEFAULT true NOT NULL,
	hs_code text NULL,
	origin_country text NULL,
	mid_code text NULL,
	material text NULL,
	weight int4 NULL,
	length int4 NULL,
	height int4 NULL,
	width int4 NULL,
	metadata jsonb NULL,
	variant_rank int4 DEFAULT 0 NULL,
	product_id text NULL,
	created_at timestamptz DEFAULT now() NOT NULL,
	updated_at timestamptz DEFAULT now() NOT NULL,
	deleted_at timestamptz NULL,
	CONSTRAINT product_variant_pkey PRIMARY KEY (id),
	CONSTRAINT product_variant_product_id_foreign FOREIGN KEY (product_id) REFERENCES public.product(id) ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE UNIQUE INDEX "IDX_product_variant_barcode_unique" ON public.product_variant USING btree (barcode) WHERE (deleted_at IS NULL);
CREATE INDEX "IDX_product_variant_deleted_at" ON public.product_variant USING btree (deleted_at);
CREATE UNIQUE INDEX "IDX_product_variant_ean_unique" ON public.product_variant USING btree (ean) WHERE (deleted_at IS NULL);
CREATE INDEX "IDX_product_variant_product_id" ON public.product_variant USING btree (product_id) WHERE (deleted_at IS NULL);
CREATE UNIQUE INDEX "IDX_product_variant_sku_unique" ON public.product_variant USING btree (sku) WHERE (deleted_at IS NULL);
CREATE UNIQUE INDEX "IDX_product_variant_upc_unique" ON public.product_variant USING btree (upc) WHERE (deleted_at IS NULL);


-- public.product_variant_option definition

-- Drop table

-- DROP TABLE public.product_variant_option;

CREATE TABLE public.product_variant_option (
	variant_id text NOT NULL,
	option_value_id text NOT NULL,
	CONSTRAINT product_variant_option_pkey PRIMARY KEY (variant_id, option_value_id),
	CONSTRAINT product_variant_option_option_value_id_foreign FOREIGN KEY (option_value_id) REFERENCES public.product_option_value(id) ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT product_variant_option_variant_id_foreign FOREIGN KEY (variant_id) REFERENCES public.product_variant(id) ON DELETE CASCADE ON UPDATE CASCADE
);


-- public.promotion definition

-- Drop table

-- DROP TABLE public.promotion;

CREATE TABLE public.promotion (
	id text NOT NULL,
	code text NOT NULL,
	campaign_id text NULL,
	is_automatic bool DEFAULT false NOT NULL,
	"type" text NOT NULL,
	created_at timestamptz DEFAULT now() NOT NULL,
	updated_at timestamptz DEFAULT now() NOT NULL,
	deleted_at timestamptz NULL,
	CONSTRAINT "IDX_promotion_code_unique" UNIQUE (code),
	CONSTRAINT promotion_pkey PRIMARY KEY (id),
	CONSTRAINT promotion_type_check CHECK ((type = ANY (ARRAY['standard'::text, 'buyget'::text]))),
	CONSTRAINT promotion_campaign_id_foreign FOREIGN KEY (campaign_id) REFERENCES public.promotion_campaign(id) ON DELETE SET NULL ON UPDATE CASCADE
);
CREATE INDEX "IDX_promotion_campaign_id" ON public.promotion USING btree (campaign_id) WHERE (deleted_at IS NULL);
CREATE INDEX "IDX_promotion_code" ON public.promotion USING btree (code);
CREATE INDEX "IDX_promotion_deleted_at" ON public.promotion USING btree (deleted_at) WHERE (deleted_at IS NULL);
CREATE INDEX "IDX_promotion_type" ON public.promotion USING btree (type);


-- public.promotion_application_method definition

-- Drop table

-- DROP TABLE public.promotion_application_method;

CREATE TABLE public.promotion_application_method (
	id text NOT NULL,
	value numeric NULL,
	raw_value jsonb NULL,
	max_quantity int4 NULL,
	apply_to_quantity int4 NULL,
	buy_rules_min_quantity int4 NULL,
	"type" text NOT NULL,
	target_type text NOT NULL,
	allocation text NULL,
	promotion_id text NOT NULL,
	created_at timestamptz DEFAULT now() NOT NULL,
	updated_at timestamptz DEFAULT now() NOT NULL,
	deleted_at timestamptz NULL,
	currency_code text NULL,
	CONSTRAINT promotion_application_method_allocation_check CHECK ((allocation = ANY (ARRAY['each'::text, 'across'::text]))),
	CONSTRAINT promotion_application_method_pkey PRIMARY KEY (id),
	CONSTRAINT promotion_application_method_promotion_id_unique UNIQUE (promotion_id),
	CONSTRAINT promotion_application_method_target_type_check CHECK ((target_type = ANY (ARRAY['order'::text, 'shipping_methods'::text, 'items'::text]))),
	CONSTRAINT promotion_application_method_type_check CHECK ((type = ANY (ARRAY['fixed'::text, 'percentage'::text]))),
	CONSTRAINT promotion_application_method_promotion_id_foreign FOREIGN KEY (promotion_id) REFERENCES public.promotion(id) ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE INDEX "IDX_application_method_allocation" ON public.promotion_application_method USING btree (allocation);
CREATE INDEX "IDX_application_method_target_type" ON public.promotion_application_method USING btree (target_type);
CREATE INDEX "IDX_application_method_type" ON public.promotion_application_method USING btree (type);
CREATE INDEX "IDX_promotion_application_method_currency_code" ON public.promotion_application_method USING btree (currency_code) WHERE (deleted_at IS NOT NULL);
CREATE INDEX "IDX_promotion_application_method_deleted_at" ON public.promotion_application_method USING btree (deleted_at) WHERE (deleted_at IS NULL);
CREATE INDEX "IDX_promotion_application_method_promotion_id" ON public.promotion_application_method USING btree (promotion_id) WHERE (deleted_at IS NULL);


-- public.promotion_campaign_budget definition

-- Drop table

-- DROP TABLE public.promotion_campaign_budget;

CREATE TABLE public.promotion_campaign_budget (
	id text NOT NULL,
	"type" text NOT NULL,
	campaign_id text NOT NULL,
	"limit" numeric NULL,
	raw_limit jsonb NULL,
	used numeric DEFAULT 0 NOT NULL,
	raw_used jsonb NOT NULL,
	created_at timestamptz DEFAULT now() NOT NULL,
	updated_at timestamptz DEFAULT now() NOT NULL,
	deleted_at timestamptz NULL,
	currency_code text NULL,
	CONSTRAINT promotion_campaign_budget_campaign_id_unique UNIQUE (campaign_id),
	CONSTRAINT promotion_campaign_budget_pkey PRIMARY KEY (id),
	CONSTRAINT promotion_campaign_budget_type_check CHECK ((type = ANY (ARRAY['spend'::text, 'usage'::text]))),
	CONSTRAINT promotion_campaign_budget_campaign_id_foreign FOREIGN KEY (campaign_id) REFERENCES public.promotion_campaign(id) ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE INDEX "IDX_campaign_budget_type" ON public.promotion_campaign_budget USING btree (type);
CREATE INDEX "IDX_promotion_campaign_budget_campaign_id" ON public.promotion_campaign_budget USING btree (campaign_id) WHERE (deleted_at IS NULL);
CREATE INDEX "IDX_promotion_campaign_budget_deleted_at" ON public.promotion_campaign_budget USING btree (deleted_at) WHERE (deleted_at IS NULL);


-- public.promotion_promotion_rule definition

-- Drop table

-- DROP TABLE public.promotion_promotion_rule;

CREATE TABLE public.promotion_promotion_rule (
	promotion_id text NOT NULL,
	promotion_rule_id text NOT NULL,
	CONSTRAINT promotion_promotion_rule_pkey PRIMARY KEY (promotion_id, promotion_rule_id),
	CONSTRAINT promotion_promotion_rule_promotion_id_foreign FOREIGN KEY (promotion_id) REFERENCES public.promotion(id) ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT promotion_promotion_rule_promotion_rule_id_foreign FOREIGN KEY (promotion_rule_id) REFERENCES public.promotion_rule(id) ON DELETE CASCADE ON UPDATE CASCADE
);


-- public.promotion_rule_value definition

-- Drop table

-- DROP TABLE public.promotion_rule_value;

CREATE TABLE public.promotion_rule_value (
	id text NOT NULL,
	promotion_rule_id text NOT NULL,
	value text NOT NULL,
	created_at timestamptz DEFAULT now() NOT NULL,
	updated_at timestamptz DEFAULT now() NOT NULL,
	deleted_at timestamptz NULL,
	CONSTRAINT promotion_rule_value_pkey PRIMARY KEY (id),
	CONSTRAINT promotion_rule_value_promotion_rule_id_foreign FOREIGN KEY (promotion_rule_id) REFERENCES public.promotion_rule(id) ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE INDEX "IDX_promotion_rule_value_deleted_at" ON public.promotion_rule_value USING btree (deleted_at) WHERE (deleted_at IS NULL);
CREATE INDEX "IDX_promotion_rule_value_promotion_rule_id" ON public.promotion_rule_value USING btree (promotion_rule_id) WHERE (deleted_at IS NULL);


-- public.provider_identity definition

-- Drop table

-- DROP TABLE public.provider_identity;

CREATE TABLE public.provider_identity (
	id text NOT NULL,
	entity_id text NOT NULL,
	provider text NOT NULL,
	auth_identity_id text NOT NULL,
	user_metadata jsonb NULL,
	provider_metadata jsonb NULL,
	created_at timestamptz DEFAULT now() NOT NULL,
	updated_at timestamptz DEFAULT now() NOT NULL,
	deleted_at timestamptz NULL,
	CONSTRAINT provider_identity_pkey PRIMARY KEY (id),
	CONSTRAINT provider_identity_auth_identity_id_foreign FOREIGN KEY (auth_identity_id) REFERENCES public.auth_identity(id) ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE INDEX "IDX_provider_identity_auth_identity_id" ON public.provider_identity USING btree (auth_identity_id);
CREATE INDEX "IDX_provider_identity_deleted_at" ON public.provider_identity USING btree (deleted_at) WHERE (deleted_at IS NULL);
CREATE UNIQUE INDEX "IDX_provider_identity_provider_entity_id" ON public.provider_identity USING btree (entity_id, provider);


-- public.refund definition

-- Drop table

-- DROP TABLE public.refund;

CREATE TABLE public.refund (
	id text NOT NULL,
	amount numeric NOT NULL,
	raw_amount jsonb NOT NULL,
	payment_id text NOT NULL,
	created_at timestamptz DEFAULT now() NOT NULL,
	updated_at timestamptz DEFAULT now() NOT NULL,
	deleted_at timestamptz NULL,
	created_by text NULL,
	metadata jsonb NULL,
	refund_reason_id text NULL,
	note text NULL,
	CONSTRAINT refund_pkey PRIMARY KEY (id),
	CONSTRAINT refund_payment_id_foreign FOREIGN KEY (payment_id) REFERENCES public.payment(id) ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE INDEX "IDX_refund_deleted_at" ON public.refund USING btree (deleted_at);
CREATE INDEX "IDX_refund_payment_id" ON public.refund USING btree (payment_id) WHERE (deleted_at IS NULL);
CREATE INDEX "IDX_refund_refund_reason_id" ON public.refund USING btree (refund_reason_id) WHERE (deleted_at IS NULL);


-- public.region_country definition

-- Drop table

-- DROP TABLE public.region_country;

CREATE TABLE public.region_country (
	iso_2 text NOT NULL,
	iso_3 text NOT NULL,
	num_code text NOT NULL,
	"name" text NOT NULL,
	display_name text NOT NULL,
	region_id text NULL,
	metadata jsonb NULL,
	created_at timestamptz DEFAULT now() NOT NULL,
	updated_at timestamptz DEFAULT now() NOT NULL,
	deleted_at timestamptz NULL,
	CONSTRAINT region_country_pkey PRIMARY KEY (iso_2),
	CONSTRAINT region_country_region_id_foreign FOREIGN KEY (region_id) REFERENCES public.region(id) ON DELETE SET NULL ON UPDATE CASCADE
);
CREATE UNIQUE INDEX "IDX_region_country_region_id_iso_2_unique" ON public.region_country USING btree (region_id, iso_2);


-- public.reservation_item definition

-- Drop table

-- DROP TABLE public.reservation_item;

CREATE TABLE public.reservation_item (
	id text NOT NULL,
	created_at timestamptz DEFAULT now() NOT NULL,
	updated_at timestamptz DEFAULT now() NOT NULL,
	deleted_at timestamptz NULL,
	line_item_id text NULL,
	location_id text NOT NULL,
	quantity numeric NOT NULL,
	external_id text NULL,
	description text NULL,
	created_by text NULL,
	metadata jsonb NULL,
	inventory_item_id text NOT NULL,
	allow_backorder bool DEFAULT false NULL,
	raw_quantity jsonb NULL,
	CONSTRAINT reservation_item_pkey PRIMARY KEY (id),
	CONSTRAINT reservation_item_inventory_item_id_foreign FOREIGN KEY (inventory_item_id) REFERENCES public.inventory_item(id) ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE INDEX "IDX_reservation_item_deleted_at" ON public.reservation_item USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);
CREATE INDEX "IDX_reservation_item_inventory_item_id" ON public.reservation_item USING btree (inventory_item_id) WHERE (deleted_at IS NULL);
CREATE INDEX "IDX_reservation_item_line_item_id" ON public.reservation_item USING btree (line_item_id) WHERE (deleted_at IS NULL);
CREATE INDEX "IDX_reservation_item_location_id" ON public.reservation_item USING btree (location_id) WHERE (deleted_at IS NULL);


-- public.return_reason definition

-- Drop table

-- DROP TABLE public.return_reason;

CREATE TABLE public.return_reason (
	id varchar NOT NULL,
	value varchar NOT NULL,
	"label" varchar NOT NULL,
	description varchar NULL,
	metadata jsonb NULL,
	parent_return_reason_id varchar NULL,
	created_at timestamptz DEFAULT now() NOT NULL,
	updated_at timestamptz DEFAULT now() NOT NULL,
	deleted_at timestamptz NULL,
	CONSTRAINT return_reason_pkey PRIMARY KEY (id),
	CONSTRAINT return_reason_parent_return_reason_id_foreign FOREIGN KEY (parent_return_reason_id) REFERENCES public.return_reason(id)
);
CREATE UNIQUE INDEX "IDX_return_reason_value" ON public.return_reason USING btree (value) WHERE (deleted_at IS NULL);


-- public.service_zone definition

-- Drop table

-- DROP TABLE public.service_zone;

CREATE TABLE public.service_zone (
	id text NOT NULL,
	"name" text NOT NULL,
	metadata jsonb NULL,
	fulfillment_set_id text NOT NULL,
	created_at timestamptz DEFAULT now() NOT NULL,
	updated_at timestamptz DEFAULT now() NOT NULL,
	deleted_at timestamptz NULL,
	CONSTRAINT service_zone_pkey PRIMARY KEY (id),
	CONSTRAINT service_zone_fulfillment_set_id_foreign FOREIGN KEY (fulfillment_set_id) REFERENCES public.fulfillment_set(id) ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE INDEX "IDX_service_zone_deleted_at" ON public.service_zone USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);
CREATE INDEX "IDX_service_zone_fulfillment_set_id" ON public.service_zone USING btree (fulfillment_set_id) WHERE (deleted_at IS NULL);
CREATE UNIQUE INDEX "IDX_service_zone_name_unique" ON public.service_zone USING btree (name) WHERE (deleted_at IS NULL);


-- public.shipping_option definition

-- Drop table

-- DROP TABLE public.shipping_option;

CREATE TABLE public.shipping_option (
	id text NOT NULL,
	"name" text NOT NULL,
	price_type text DEFAULT 'flat'::text NOT NULL,
	service_zone_id text NOT NULL,
	shipping_profile_id text NULL,
	provider_id text NULL,
	"data" jsonb NULL,
	metadata jsonb NULL,
	shipping_option_type_id text NOT NULL,
	created_at timestamptz DEFAULT now() NOT NULL,
	updated_at timestamptz DEFAULT now() NOT NULL,
	deleted_at timestamptz NULL,
	CONSTRAINT shipping_option_pkey PRIMARY KEY (id),
	CONSTRAINT shipping_option_price_type_check CHECK ((price_type = ANY (ARRAY['calculated'::text, 'flat'::text]))),
	CONSTRAINT shipping_option_service_zone_id_foreign FOREIGN KEY (service_zone_id) REFERENCES public.service_zone(id) ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT shipping_option_shipping_profile_id_foreign FOREIGN KEY (shipping_profile_id) REFERENCES public.shipping_profile(id) ON DELETE SET NULL ON UPDATE CASCADE
);
CREATE INDEX "IDX_shipping_option_deleted_at" ON public.shipping_option USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);
CREATE INDEX "IDX_shipping_option_service_zone_id" ON public.shipping_option USING btree (service_zone_id) WHERE (deleted_at IS NULL);
CREATE INDEX "IDX_shipping_option_shipping_profile_id" ON public.shipping_option USING btree (shipping_profile_id) WHERE (deleted_at IS NULL);


-- public.shipping_option_rule definition

-- Drop table

-- DROP TABLE public.shipping_option_rule;

CREATE TABLE public.shipping_option_rule (
	id text NOT NULL,
	"attribute" text NOT NULL,
	"operator" text NOT NULL,
	value jsonb NULL,
	shipping_option_id text NOT NULL,
	created_at timestamptz DEFAULT now() NOT NULL,
	updated_at timestamptz DEFAULT now() NOT NULL,
	deleted_at timestamptz NULL,
	CONSTRAINT shipping_option_rule_operator_check CHECK ((operator = ANY (ARRAY['in'::text, 'eq'::text, 'ne'::text, 'gt'::text, 'gte'::text, 'lt'::text, 'lte'::text, 'nin'::text]))),
	CONSTRAINT shipping_option_rule_pkey PRIMARY KEY (id),
	CONSTRAINT shipping_option_rule_shipping_option_id_foreign FOREIGN KEY (shipping_option_id) REFERENCES public.shipping_option(id) ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE INDEX "IDX_shipping_option_rule_deleted_at" ON public.shipping_option_rule USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);
CREATE INDEX "IDX_shipping_option_rule_shipping_option_id" ON public.shipping_option_rule USING btree (shipping_option_id) WHERE (deleted_at IS NULL);


-- public.stock_location definition

-- Drop table

-- DROP TABLE public.stock_location;

CREATE TABLE public.stock_location (
	id text NOT NULL,
	created_at timestamptz DEFAULT now() NOT NULL,
	updated_at timestamptz DEFAULT now() NOT NULL,
	deleted_at timestamptz NULL,
	"name" text NOT NULL,
	address_id text NULL,
	metadata jsonb NULL,
	CONSTRAINT stock_location_address_id_unique UNIQUE (address_id),
	CONSTRAINT stock_location_pkey PRIMARY KEY (id),
	CONSTRAINT stock_location_address_id_foreign FOREIGN KEY (address_id) REFERENCES public.stock_location_address(id) ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE INDEX "IDX_stock_location_address_id" ON public.stock_location USING btree (address_id) WHERE (deleted_at IS NULL);
CREATE INDEX "IDX_stock_location_deleted_at" ON public.stock_location USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


-- public.store_currency definition

-- Drop table

-- DROP TABLE public.store_currency;

CREATE TABLE public.store_currency (
	id text NOT NULL,
	currency_code text NOT NULL,
	is_default bool DEFAULT false NOT NULL,
	store_id text NULL,
	created_at timestamptz DEFAULT now() NOT NULL,
	updated_at timestamptz DEFAULT now() NOT NULL,
	deleted_at timestamptz NULL,
	CONSTRAINT store_currency_pkey PRIMARY KEY (id),
	CONSTRAINT store_currency_store_id_foreign FOREIGN KEY (store_id) REFERENCES public.store(id) ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE INDEX "IDX_store_currency_deleted_at" ON public.store_currency USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);
CREATE INDEX "IDX_store_currency_store_id" ON public.store_currency USING btree (store_id) WHERE (deleted_at IS NULL);


-- public.tax_region definition

-- Drop table

-- DROP TABLE public.tax_region;

CREATE TABLE public.tax_region (
	id text NOT NULL,
	provider_id text NULL,
	country_code text NOT NULL,
	province_code text NULL,
	parent_id text NULL,
	metadata jsonb NULL,
	created_at timestamptz DEFAULT now() NOT NULL,
	updated_at timestamptz DEFAULT now() NOT NULL,
	created_by text NULL,
	deleted_at timestamptz NULL,
	CONSTRAINT "CK_tax_region_country_top_level" CHECK (((parent_id IS NULL) OR (province_code IS NOT NULL))),
	CONSTRAINT "CK_tax_region_provider_top_level" CHECK (((parent_id IS NULL) OR (provider_id IS NULL))),
	CONSTRAINT tax_region_pkey PRIMARY KEY (id),
	CONSTRAINT "FK_tax_region_parent_id" FOREIGN KEY (parent_id) REFERENCES public.tax_region(id) ON DELETE CASCADE,
	CONSTRAINT "FK_tax_region_provider_id" FOREIGN KEY (provider_id) REFERENCES public.tax_provider(id) ON DELETE SET NULL
);
CREATE INDEX "IDX_tax_region_deleted_at" ON public.tax_region USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);
CREATE INDEX "IDX_tax_region_parent_id" ON public.tax_region USING btree (parent_id);
CREATE INDEX "IDX_tax_region_provider_id" ON public.tax_region USING btree (provider_id) WHERE (deleted_at IS NULL);
CREATE UNIQUE INDEX "IDX_tax_region_unique_country_nullable_province" ON public.tax_region USING btree (country_code) WHERE ((province_code IS NULL) AND (deleted_at IS NULL));
CREATE UNIQUE INDEX "IDX_tax_region_unique_country_province" ON public.tax_region USING btree (country_code, province_code) WHERE (deleted_at IS NULL);


-- public.application_method_buy_rules definition

-- Drop table

-- DROP TABLE public.application_method_buy_rules;

CREATE TABLE public.application_method_buy_rules (
	application_method_id text NOT NULL,
	promotion_rule_id text NOT NULL,
	CONSTRAINT application_method_buy_rules_pkey PRIMARY KEY (application_method_id, promotion_rule_id),
	CONSTRAINT application_method_buy_rules_application_method_id_foreign FOREIGN KEY (application_method_id) REFERENCES public.promotion_application_method(id) ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT application_method_buy_rules_promotion_rule_id_foreign FOREIGN KEY (promotion_rule_id) REFERENCES public.promotion_rule(id) ON DELETE CASCADE ON UPDATE CASCADE
);


-- public.application_method_target_rules definition

-- Drop table

-- DROP TABLE public.application_method_target_rules;

CREATE TABLE public.application_method_target_rules (
	application_method_id text NOT NULL,
	promotion_rule_id text NOT NULL,
	CONSTRAINT application_method_target_rules_pkey PRIMARY KEY (application_method_id, promotion_rule_id),
	CONSTRAINT application_method_target_rules_application_method_id_foreign FOREIGN KEY (application_method_id) REFERENCES public.promotion_application_method(id) ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT application_method_target_rules_promotion_rule_id_foreign FOREIGN KEY (promotion_rule_id) REFERENCES public.promotion_rule(id) ON DELETE CASCADE ON UPDATE CASCADE
);


-- public.capture definition

-- Drop table

-- DROP TABLE public.capture;

CREATE TABLE public.capture (
	id text NOT NULL,
	amount numeric NOT NULL,
	raw_amount jsonb NOT NULL,
	payment_id text NOT NULL,
	created_at timestamptz DEFAULT now() NOT NULL,
	updated_at timestamptz DEFAULT now() NOT NULL,
	deleted_at timestamptz NULL,
	created_by text NULL,
	metadata jsonb NULL,
	CONSTRAINT capture_pkey PRIMARY KEY (id),
	CONSTRAINT capture_payment_id_foreign FOREIGN KEY (payment_id) REFERENCES public.payment(id) ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE INDEX "IDX_capture_deleted_at" ON public.capture USING btree (deleted_at);
CREATE INDEX "IDX_capture_payment_id" ON public.capture USING btree (payment_id) WHERE (deleted_at IS NULL);


-- public.fulfillment definition

-- Drop table

-- DROP TABLE public.fulfillment;

CREATE TABLE public.fulfillment (
	id text NOT NULL,
	location_id text NOT NULL,
	packed_at timestamptz NULL,
	shipped_at timestamptz NULL,
	delivered_at timestamptz NULL,
	canceled_at timestamptz NULL,
	"data" jsonb NULL,
	provider_id text NULL,
	shipping_option_id text NULL,
	metadata jsonb NULL,
	delivery_address_id text NULL,
	created_at timestamptz DEFAULT now() NOT NULL,
	updated_at timestamptz DEFAULT now() NOT NULL,
	deleted_at timestamptz NULL,
	marked_shipped_by text NULL,
	created_by text NULL,
	requires_shipping bool DEFAULT true NOT NULL,
	CONSTRAINT fulfillment_pkey PRIMARY KEY (id),
	CONSTRAINT fulfillment_shipping_option_id_foreign FOREIGN KEY (shipping_option_id) REFERENCES public.shipping_option(id) ON DELETE SET NULL ON UPDATE CASCADE
);
CREATE INDEX "IDX_fulfillment_deleted_at" ON public.fulfillment USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);
CREATE INDEX "IDX_fulfillment_location_id" ON public.fulfillment USING btree (location_id) WHERE (deleted_at IS NULL);
CREATE INDEX "IDX_fulfillment_shipping_option_id" ON public.fulfillment USING btree (shipping_option_id) WHERE (deleted_at IS NULL);


-- public.fulfillment_item definition

-- Drop table

-- DROP TABLE public.fulfillment_item;

CREATE TABLE public.fulfillment_item (
	id text NOT NULL,
	title text NOT NULL,
	sku text NOT NULL,
	barcode text NOT NULL,
	quantity numeric NOT NULL,
	raw_quantity jsonb NOT NULL,
	line_item_id text NULL,
	inventory_item_id text NULL,
	fulfillment_id text NOT NULL,
	created_at timestamptz DEFAULT now() NOT NULL,
	updated_at timestamptz DEFAULT now() NOT NULL,
	deleted_at timestamptz NULL,
	CONSTRAINT fulfillment_item_pkey PRIMARY KEY (id),
	CONSTRAINT fulfillment_item_fulfillment_id_foreign FOREIGN KEY (fulfillment_id) REFERENCES public.fulfillment(id) ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE INDEX "IDX_fulfillment_item_deleted_at" ON public.fulfillment_item USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);
CREATE INDEX "IDX_fulfillment_item_fulfillment_id" ON public.fulfillment_item USING btree (fulfillment_id) WHERE (deleted_at IS NULL);
CREATE INDEX "IDX_fulfillment_item_inventory_item_id" ON public.fulfillment_item USING btree (inventory_item_id) WHERE (deleted_at IS NULL);
CREATE INDEX "IDX_fulfillment_item_line_item_id" ON public.fulfillment_item USING btree (line_item_id) WHERE (deleted_at IS NULL);


-- public.fulfillment_label definition

-- Drop table

-- DROP TABLE public.fulfillment_label;

CREATE TABLE public.fulfillment_label (
	id text NOT NULL,
	tracking_number text NOT NULL,
	tracking_url text NOT NULL,
	label_url text NOT NULL,
	fulfillment_id text NOT NULL,
	created_at timestamptz DEFAULT now() NOT NULL,
	updated_at timestamptz DEFAULT now() NOT NULL,
	deleted_at timestamptz NULL,
	CONSTRAINT fulfillment_label_pkey PRIMARY KEY (id),
	CONSTRAINT fulfillment_label_fulfillment_id_foreign FOREIGN KEY (fulfillment_id) REFERENCES public.fulfillment(id) ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE INDEX "IDX_fulfillment_label_deleted_at" ON public.fulfillment_label USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);
CREATE INDEX "IDX_fulfillment_label_fulfillment_id" ON public.fulfillment_label USING btree (fulfillment_id) WHERE (deleted_at IS NULL);


-- public.geo_zone definition

-- Drop table

-- DROP TABLE public.geo_zone;

CREATE TABLE public.geo_zone (
	id text NOT NULL,
	"type" text DEFAULT 'country'::text NOT NULL,
	country_code text NOT NULL,
	province_code text NULL,
	city text NULL,
	service_zone_id text NOT NULL,
	postal_expression jsonb NULL,
	metadata jsonb NULL,
	created_at timestamptz DEFAULT now() NOT NULL,
	updated_at timestamptz DEFAULT now() NOT NULL,
	deleted_at timestamptz NULL,
	CONSTRAINT geo_zone_pkey PRIMARY KEY (id),
	CONSTRAINT geo_zone_type_check CHECK ((type = ANY (ARRAY['country'::text, 'province'::text, 'city'::text, 'zip'::text]))),
	CONSTRAINT geo_zone_service_zone_id_foreign FOREIGN KEY (service_zone_id) REFERENCES public.service_zone(id) ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE INDEX "IDX_geo_zone_city" ON public.geo_zone USING btree (city) WHERE ((deleted_at IS NULL) AND (city IS NOT NULL));
CREATE INDEX "IDX_geo_zone_country_code" ON public.geo_zone USING btree (country_code) WHERE (deleted_at IS NULL);
CREATE INDEX "IDX_geo_zone_deleted_at" ON public.geo_zone USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);
CREATE INDEX "IDX_geo_zone_province_code" ON public.geo_zone USING btree (province_code) WHERE ((deleted_at IS NULL) AND (province_code IS NOT NULL));
CREATE INDEX "IDX_geo_zone_service_zone_id" ON public.geo_zone USING btree (service_zone_id) WHERE (deleted_at IS NULL);


-- public.image definition

-- Drop table

-- DROP TABLE public.image;

CREATE TABLE public.image (
	id text NOT NULL,
	url text NOT NULL,
	metadata jsonb NULL,
	created_at timestamptz DEFAULT now() NOT NULL,
	updated_at timestamptz DEFAULT now() NOT NULL,
	deleted_at timestamptz NULL,
	"rank" int4 DEFAULT 0 NOT NULL,
	product_id text NOT NULL,
	CONSTRAINT image_pkey PRIMARY KEY (id),
	CONSTRAINT image_product_id_foreign FOREIGN KEY (product_id) REFERENCES public.product(id) ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE INDEX "IDX_image_deleted_at" ON public.image USING btree (deleted_at) WHERE (deleted_at IS NULL);
CREATE INDEX "IDX_product_image_url" ON public.image USING btree (url) WHERE (deleted_at IS NULL);


-- public.tax_rate definition

-- Drop table

-- DROP TABLE public.tax_rate;

CREATE TABLE public.tax_rate (
	id text NOT NULL,
	rate float4 NULL,
	code text NOT NULL,
	"name" text NOT NULL,
	is_default bool DEFAULT false NOT NULL,
	is_combinable bool DEFAULT false NOT NULL,
	tax_region_id text NOT NULL,
	metadata jsonb NULL,
	created_at timestamptz DEFAULT now() NOT NULL,
	updated_at timestamptz DEFAULT now() NOT NULL,
	created_by text NULL,
	deleted_at timestamptz NULL,
	CONSTRAINT tax_rate_pkey PRIMARY KEY (id),
	CONSTRAINT "FK_tax_rate_tax_region_id" FOREIGN KEY (tax_region_id) REFERENCES public.tax_region(id) ON DELETE CASCADE
);
CREATE UNIQUE INDEX "IDX_single_default_region" ON public.tax_rate USING btree (tax_region_id) WHERE ((is_default = true) AND (deleted_at IS NULL));
CREATE INDEX "IDX_tax_rate_deleted_at" ON public.tax_rate USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);
CREATE INDEX "IDX_tax_rate_tax_region_id" ON public.tax_rate USING btree (tax_region_id) WHERE (deleted_at IS NULL);


-- public.tax_rate_rule definition

-- Drop table

-- DROP TABLE public.tax_rate_rule;

CREATE TABLE public.tax_rate_rule (
	id text NOT NULL,
	tax_rate_id text NOT NULL,
	reference_id text NOT NULL,
	reference text NOT NULL,
	metadata jsonb NULL,
	created_at timestamptz DEFAULT now() NOT NULL,
	updated_at timestamptz DEFAULT now() NOT NULL,
	created_by text NULL,
	deleted_at timestamptz NULL,
	CONSTRAINT tax_rate_rule_pkey PRIMARY KEY (id),
	CONSTRAINT "FK_tax_rate_rule_tax_rate_id" FOREIGN KEY (tax_rate_id) REFERENCES public.tax_rate(id) ON DELETE CASCADE
);
CREATE INDEX "IDX_tax_rate_rule_deleted_at" ON public.tax_rate_rule USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);
CREATE INDEX "IDX_tax_rate_rule_reference_id" ON public.tax_rate_rule USING btree (reference_id) WHERE (deleted_at IS NULL);
CREATE INDEX "IDX_tax_rate_rule_tax_rate_id" ON public.tax_rate_rule USING btree (tax_rate_id) WHERE (deleted_at IS NULL);
CREATE UNIQUE INDEX "IDX_tax_rate_rule_unique_rate_reference" ON public.tax_rate_rule USING btree (tax_rate_id, reference_id) WHERE (deleted_at IS NULL);


-- public.order_item definition

-- Drop table

-- DROP TABLE public.order_item;

CREATE TABLE public.order_item (
	id text NOT NULL,
	order_id text NOT NULL,
	"version" int4 NOT NULL,
	item_id text NOT NULL,
	quantity numeric NOT NULL,
	raw_quantity jsonb NOT NULL,
	fulfilled_quantity numeric NOT NULL,
	raw_fulfilled_quantity jsonb NOT NULL,
	shipped_quantity numeric NOT NULL,
	raw_shipped_quantity jsonb NOT NULL,
	return_requested_quantity numeric NOT NULL,
	raw_return_requested_quantity jsonb NOT NULL,
	return_received_quantity numeric NOT NULL,
	raw_return_received_quantity jsonb NOT NULL,
	return_dismissed_quantity numeric NOT NULL,
	raw_return_dismissed_quantity jsonb NOT NULL,
	written_off_quantity numeric NOT NULL,
	raw_written_off_quantity jsonb NOT NULL,
	metadata jsonb NULL,
	created_at timestamptz DEFAULT now() NOT NULL,
	updated_at timestamptz DEFAULT now() NOT NULL,
	deleted_at timestamptz NULL,
	delivered_quantity numeric DEFAULT 0 NOT NULL,
	raw_delivered_quantity jsonb NOT NULL,
	unit_price numeric NULL,
	raw_unit_price jsonb NULL,
	compare_at_unit_price numeric NULL,
	raw_compare_at_unit_price jsonb NULL,
	CONSTRAINT order_item_pkey PRIMARY KEY (id)
);
CREATE INDEX "IDX_order_item_deleted_at" ON public.order_item USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);
CREATE INDEX "IDX_order_item_item_id" ON public.order_item USING btree (item_id) WHERE (deleted_at IS NULL);
CREATE INDEX "IDX_order_item_order_id" ON public.order_item USING btree (order_id) WHERE (deleted_at IS NULL);
CREATE INDEX "IDX_order_item_order_id_version" ON public.order_item USING btree (order_id, version) WHERE (deleted_at IS NULL);


-- public.order_line_item definition

-- Drop table

-- DROP TABLE public.order_line_item;

CREATE TABLE public.order_line_item (
	id text NOT NULL,
	totals_id text NULL,
	title text NOT NULL,
	subtitle text NULL,
	thumbnail text NULL,
	variant_id text NULL,
	product_id text NULL,
	product_title text NULL,
	product_description text NULL,
	product_subtitle text NULL,
	product_type text NULL,
	product_collection text NULL,
	product_handle text NULL,
	variant_sku text NULL,
	variant_barcode text NULL,
	variant_title text NULL,
	variant_option_values jsonb NULL,
	requires_shipping bool DEFAULT true NOT NULL,
	is_discountable bool DEFAULT true NOT NULL,
	is_tax_inclusive bool DEFAULT false NOT NULL,
	compare_at_unit_price numeric NULL,
	raw_compare_at_unit_price jsonb NULL,
	unit_price numeric NOT NULL,
	raw_unit_price jsonb NOT NULL,
	metadata jsonb NULL,
	created_at timestamptz DEFAULT now() NOT NULL,
	updated_at timestamptz DEFAULT now() NOT NULL,
	deleted_at timestamptz NULL,
	is_custom_price bool DEFAULT false NOT NULL,
	product_type_id text NULL,
	CONSTRAINT order_line_item_pkey PRIMARY KEY (id)
);
CREATE INDEX "IDX_order_line_item_product_id" ON public.order_line_item USING btree (product_id) WHERE (deleted_at IS NULL);
CREATE INDEX "IDX_order_line_item_variant_id" ON public.order_line_item USING btree (variant_id) WHERE (deleted_at IS NULL);


-- public.order_line_item_adjustment definition

-- Drop table

-- DROP TABLE public.order_line_item_adjustment;

CREATE TABLE public.order_line_item_adjustment (
	id text NOT NULL,
	description text NULL,
	promotion_id text NULL,
	code text NULL,
	amount numeric NOT NULL,
	raw_amount jsonb NOT NULL,
	provider_id text NULL,
	created_at timestamptz DEFAULT now() NOT NULL,
	updated_at timestamptz DEFAULT now() NOT NULL,
	item_id text NOT NULL,
	deleted_at timestamptz NULL,
	CONSTRAINT order_line_item_adjustment_pkey PRIMARY KEY (id)
);
CREATE INDEX "IDX_order_line_item_adjustment_item_id" ON public.order_line_item_adjustment USING btree (item_id) WHERE (deleted_at IS NULL);


-- public.order_line_item_tax_line definition

-- Drop table

-- DROP TABLE public.order_line_item_tax_line;

CREATE TABLE public.order_line_item_tax_line (
	id text NOT NULL,
	description text NULL,
	tax_rate_id text NULL,
	code text NOT NULL,
	rate numeric NOT NULL,
	raw_rate jsonb NOT NULL,
	provider_id text NULL,
	created_at timestamptz DEFAULT now() NOT NULL,
	updated_at timestamptz DEFAULT now() NOT NULL,
	item_id text NOT NULL,
	deleted_at timestamptz NULL,
	CONSTRAINT order_line_item_tax_line_pkey PRIMARY KEY (id)
);
CREATE INDEX "IDX_order_line_item_tax_line_item_id" ON public.order_line_item_tax_line USING btree (item_id) WHERE (deleted_at IS NULL);


-- public.order_item foreign keys

ALTER TABLE public.order_item ADD CONSTRAINT order_item_item_id_foreign FOREIGN KEY (item_id) REFERENCES public.order_line_item(id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE public.order_item ADD CONSTRAINT order_item_order_id_foreign FOREIGN KEY (order_id) REFERENCES public."order"(id) ON DELETE CASCADE ON UPDATE CASCADE;


-- public.order_line_item foreign keys

ALTER TABLE public.order_line_item ADD CONSTRAINT order_line_item_totals_id_foreign FOREIGN KEY (totals_id) REFERENCES public.order_item(id) ON DELETE CASCADE ON UPDATE CASCADE;


-- public.order_line_item_adjustment foreign keys

ALTER TABLE public.order_line_item_adjustment ADD CONSTRAINT order_line_item_adjustment_item_id_foreign FOREIGN KEY (item_id) REFERENCES public.order_line_item(id) ON DELETE CASCADE ON UPDATE CASCADE;


-- public.order_line_item_tax_line foreign keys

ALTER TABLE public.order_line_item_tax_line ADD CONSTRAINT order_line_item_tax_line_item_id_foreign FOREIGN KEY (item_id) REFERENCES public.order_line_item(id) ON DELETE CASCADE ON UPDATE CASCADE;