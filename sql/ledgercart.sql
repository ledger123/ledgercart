--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET client_encoding = 'SQL_ASCII';
SET standard_conforming_strings = off;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET escape_string_warning = off;

--
-- Name: plpgsql; Type: PROCEDURAL LANGUAGE; Schema: -; Owner: postgres
--

CREATE PROCEDURAL LANGUAGE plpgsql;


ALTER PROCEDURAL LANGUAGE plpgsql OWNER TO postgres;

SET search_path = public, pg_catalog;

--
-- Name: del_department(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION del_department() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
begin
  delete from dpt_trans where trans_id = old.id;
  return NULL;
end;
$$;


ALTER FUNCTION public.del_department() OWNER TO postgres;

--
-- Name: entry_id; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE entry_id
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.entry_id OWNER TO postgres;

--
-- Name: entry_id; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('entry_id', 277, true);


SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: acc_trans; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE acc_trans (
    trans_id integer,
    chart_id integer,
    amount double precision,
    transdate date DEFAULT ('now'::text)::date,
    source text,
    approved boolean DEFAULT true,
    fx_transaction boolean DEFAULT false,
    project_id integer,
    memo text,
    id integer,
    cleared date,
    vr_id integer,
    entry_id integer DEFAULT nextval('entry_id'::regclass)
);


ALTER TABLE public.acc_trans OWNER TO postgres;

--
-- Name: addressid; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE addressid
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.addressid OWNER TO postgres;

--
-- Name: addressid; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('addressid', 66, true);


--
-- Name: address; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE address (
    id integer DEFAULT nextval('addressid'::regclass) NOT NULL,
    trans_id integer,
    address1 character varying(32),
    address2 character varying(32),
    city character varying(32),
    state character varying(32),
    zipcode character varying(10),
    country character varying(32)
);


ALTER TABLE public.address OWNER TO postgres;

--
-- Name: id; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE id
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.id OWNER TO postgres;

--
-- Name: id; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('id', 10243, true);


--
-- Name: ap; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE ap (
    id integer DEFAULT nextval('id'::regclass),
    invnumber text,
    transdate date DEFAULT ('now'::text)::date,
    vendor_id integer,
    taxincluded boolean DEFAULT false,
    amount double precision,
    netamount double precision,
    paid double precision,
    datepaid date,
    duedate date,
    invoice boolean DEFAULT false,
    ordnumber text,
    curr character(3),
    notes text,
    employee_id integer,
    till character varying(20),
    quonumber text,
    intnotes text,
    department_id integer DEFAULT 0,
    shipvia text,
    language_code character varying(6),
    ponumber text,
    shippingpoint text,
    terms smallint DEFAULT 0,
    approved boolean DEFAULT true,
    cashdiscount real,
    discountterms smallint,
    waybill text,
    warehouse_id integer,
    description text,
    onhold boolean DEFAULT false,
    exchangerate double precision,
    dcn text,
    bank_id integer,
    paymentmethod_id integer,
    ticket_id integer
);


ALTER TABLE public.ap OWNER TO postgres;

--
-- Name: ar; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE ar (
    id integer DEFAULT nextval('id'::regclass),
    invnumber text,
    transdate date DEFAULT ('now'::text)::date,
    customer_id integer,
    taxincluded boolean,
    amount double precision,
    netamount double precision,
    paid double precision,
    datepaid date,
    duedate date,
    invoice boolean DEFAULT false,
    shippingpoint text,
    terms smallint DEFAULT 0,
    notes text,
    curr character(3),
    ordnumber text,
    employee_id integer,
    till character varying(20),
    quonumber text,
    intnotes text,
    department_id integer DEFAULT 0,
    shipvia text,
    language_code character varying(6),
    ponumber text,
    approved boolean DEFAULT true,
    cashdiscount real,
    discountterms smallint,
    waybill text,
    warehouse_id integer,
    description text,
    onhold boolean DEFAULT false,
    exchangerate double precision,
    dcn text,
    bank_id integer,
    paymentmethod_id integer,
    ticket_id integer
);


ALTER TABLE public.ar OWNER TO postgres;

--
-- Name: assemblyid; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE assemblyid
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.assemblyid OWNER TO postgres;

--
-- Name: assemblyid; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('assemblyid', 4, true);


--
-- Name: assembly; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE assembly (
    id integer DEFAULT nextval('assemblyid'::regclass),
    parts_id integer,
    qty double precision,
    bom boolean,
    adj boolean,
    aid integer
);


ALTER TABLE public.assembly OWNER TO postgres;

--
-- Name: audittrail; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE audittrail (
    trans_id integer,
    tablename text,
    reference text,
    formname text,
    action text,
    transdate timestamp without time zone DEFAULT now(),
    employee_id integer
);


ALTER TABLE public.audittrail OWNER TO postgres;

--
-- Name: bank; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE bank (
    id integer,
    name character varying(64),
    iban character varying(34),
    bic character varying(11),
    address_id integer DEFAULT nextval('addressid'::regclass),
    dcn text,
    rvc text,
    membernumber text
);


ALTER TABLE public.bank OWNER TO postgres;

--
-- Name: br; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE br (
    id integer DEFAULT nextval('id'::regclass) NOT NULL,
    batchnumber text,
    description text,
    batch text,
    transdate date DEFAULT ('now'::text)::date,
    apprdate date,
    amount double precision,
    managerid integer,
    employee_id integer
);


ALTER TABLE public.br OWNER TO postgres;

--
-- Name: build; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE build (
    id integer DEFAULT nextval(('id'::text)::regclass) NOT NULL,
    reference text,
    transdate date,
    department_id integer,
    warehouse_id integer,
    employee_id integer
);


ALTER TABLE public.build OWNER TO postgres;

--
-- Name: business; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE business (
    id integer DEFAULT nextval('id'::regclass),
    description text,
    discount real
);


ALTER TABLE public.business OWNER TO postgres;

--
-- Name: cargo; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE cargo (
    id integer NOT NULL,
    trans_id integer NOT NULL,
    package text,
    netweight double precision,
    grossweight double precision,
    volume double precision
);


ALTER TABLE public.cargo OWNER TO postgres;

--
-- Name: chart; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE chart (
    id integer DEFAULT nextval('id'::regclass),
    accno text NOT NULL,
    description text,
    charttype character(1) DEFAULT 'A'::bpchar,
    category character(1),
    link text,
    gifi_accno text,
    contra boolean DEFAULT false
);


ALTER TABLE public.chart OWNER TO postgres;

--
-- Name: contactid; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE contactid
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.contactid OWNER TO postgres;

--
-- Name: contactid; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('contactid', 64, true);


--
-- Name: contact; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE contact (
    id integer DEFAULT nextval('contactid'::regclass) NOT NULL,
    trans_id integer NOT NULL,
    salutation character varying(32),
    firstname character varying(32),
    lastname character varying(32),
    contacttitle character varying(32),
    occupation character varying(32),
    phone character varying(20),
    fax character varying(20),
    mobile character varying(20),
    email text,
    gender character(1) DEFAULT 'M'::bpchar,
    parent_id integer,
    typeofcontact character varying(20)
);


ALTER TABLE public.contact OWNER TO postgres;

--
-- Name: curr; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE curr (
    rn integer,
    curr character(3) NOT NULL,
    "precision" smallint
);


ALTER TABLE public.curr OWNER TO postgres;

--
-- Name: customer; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE customer (
    id integer DEFAULT nextval('id'::regclass) NOT NULL,
    name character varying(64),
    contact character varying(64),
    phone character varying(20),
    fax character varying(20),
    email text,
    notes text,
    terms smallint DEFAULT 0,
    taxincluded boolean DEFAULT false,
    customernumber character varying(32),
    cc text,
    bcc text,
    business_id integer,
    taxnumber character varying(32),
    sic_code character varying(6),
    discount real,
    creditlimit double precision DEFAULT 0,
    iban character varying(34),
    bic character varying(11),
    employee_id integer,
    language_code character varying(6),
    pricegroup_id integer,
    curr character(3),
    startdate date,
    enddate date,
    arap_accno_id integer,
    payment_accno_id integer,
    discount_accno_id integer,
    cashdiscount real,
    discountterms smallint,
    threshold double precision,
    paymentmethod_id integer,
    remittancevoucher boolean
);


ALTER TABLE public.customer OWNER TO postgres;

--
-- Name: customercart; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE customercart (
    cart_id character varying(32),
    customer_id integer,
    parts_id integer,
    qty double precision DEFAULT 0,
    price double precision DEFAULT 0,
    taxaccounts text
);


ALTER TABLE public.customercart OWNER TO postgres;

--
-- Name: customerlogin; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE customerlogin (
    id integer NOT NULL,
    login character varying(100) NOT NULL,
    passwd character(32),
    session character(32),
    session_exp character varying(20),
    customer_id integer
);


ALTER TABLE public.customerlogin OWNER TO postgres;

--
-- Name: customerlogin_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE customerlogin_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.customerlogin_id_seq OWNER TO postgres;

--
-- Name: customerlogin_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE customerlogin_id_seq OWNED BY customerlogin.id;


--
-- Name: customerlogin_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('customerlogin_id_seq', 13, true);


--
-- Name: customertax; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE customertax (
    customer_id integer,
    chart_id integer
);


ALTER TABLE public.customertax OWNER TO postgres;

--
-- Name: defaults; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE defaults (
    fldname text,
    fldvalue text
);


ALTER TABLE public.defaults OWNER TO postgres;

--
-- Name: department; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE department (
    id integer DEFAULT nextval('id'::regclass),
    description text,
    role character(1) DEFAULT 'P'::bpchar
);


ALTER TABLE public.department OWNER TO postgres;

--
-- Name: dpt_trans; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE dpt_trans (
    trans_id integer,
    department_id integer
);


ALTER TABLE public.dpt_trans OWNER TO postgres;

--
-- Name: employee; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE employee (
    id integer DEFAULT nextval('id'::regclass),
    login text,
    name character varying(64),
    address1 character varying(32),
    address2 character varying(32),
    city character varying(32),
    state character varying(32),
    zipcode character varying(10),
    country character varying(32),
    workphone character varying(20),
    workfax character varying(20),
    workmobile character varying(20),
    homephone character varying(20),
    startdate date DEFAULT ('now'::text)::date,
    enddate date,
    notes text,
    role character varying(20),
    sales boolean DEFAULT false,
    email text,
    ssn character varying(20),
    iban character varying(34),
    bic character varying(11),
    managerid integer,
    employeenumber character varying(32),
    dob date
);


ALTER TABLE public.employee OWNER TO postgres;

--
-- Name: exchangerate; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE exchangerate (
    curr character(3),
    transdate date,
    buy double precision,
    sell double precision
);


ALTER TABLE public.exchangerate OWNER TO postgres;

--
-- Name: fifo; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE fifo (
    trans_id integer,
    transdate date,
    parts_id integer,
    qty double precision,
    costprice double precision,
    sellprice double precision,
    warehouse_id integer,
    invoice_id integer
);


ALTER TABLE public.fifo OWNER TO postgres;

--
-- Name: gifi; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE gifi (
    accno text,
    description text
);


ALTER TABLE public.gifi OWNER TO postgres;

--
-- Name: gl; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE gl (
    id integer DEFAULT nextval('id'::regclass),
    reference text,
    description text,
    transdate date DEFAULT ('now'::text)::date,
    employee_id integer,
    notes text,
    department_id integer DEFAULT 0,
    approved boolean DEFAULT true,
    curr character(3),
    exchangerate double precision,
    ticket_id integer
);


ALTER TABLE public.gl OWNER TO postgres;

--
-- Name: inventoryid; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE inventoryid
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.inventoryid OWNER TO postgres;

--
-- Name: inventoryid; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('inventoryid', 83, true);


--
-- Name: inventory; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE inventory (
    id integer DEFAULT nextval('inventoryid'::regclass),
    warehouse_id integer,
    parts_id integer,
    trans_id integer,
    orderitems_id integer,
    qty double precision,
    shippingdate date,
    employee_id integer,
    department_id integer,
    warehouse_id2 integer,
    serialnumber text,
    itemnotes text,
    cost double precision,
    linetype character(1) DEFAULT '0'::bpchar,
    description text,
    invoice_id integer,
    cogs double precision
);


ALTER TABLE public.inventory OWNER TO postgres;

--
-- Name: invoiceid; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE invoiceid
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.invoiceid OWNER TO postgres;

--
-- Name: invoiceid; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('invoiceid', 130, true);


--
-- Name: invoice; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE invoice (
    id integer DEFAULT nextval('invoiceid'::regclass),
    trans_id integer,
    parts_id integer,
    description text,
    qty double precision,
    allocated double precision,
    sellprice double precision,
    fxsellprice double precision,
    discount real,
    assemblyitem boolean DEFAULT false,
    unit character varying(5),
    project_id integer,
    deliverydate date,
    serialnumber text,
    itemnotes text,
    lineitemdetail boolean,
    transdate date,
    lastcost double precision,
    ordernumber text,
    ponumber text,
    warehouse_id integer,
    cogs double precision
);


ALTER TABLE public.invoice OWNER TO postgres;

--
-- Name: invoicetax; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE invoicetax (
    trans_id integer,
    invoice_id integer,
    chart_id integer,
    taxamount double precision
);


ALTER TABLE public.invoicetax OWNER TO postgres;

--
-- Name: jcitemsid; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE jcitemsid
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.jcitemsid OWNER TO postgres;

--
-- Name: jcitemsid; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('jcitemsid', 1, true);


--
-- Name: jcitems; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE jcitems (
    id integer DEFAULT nextval('jcitemsid'::regclass),
    project_id integer,
    parts_id integer,
    description text,
    qty double precision,
    allocated double precision,
    sellprice double precision,
    fxsellprice double precision,
    serialnumber text,
    checkedin timestamp with time zone,
    checkedout timestamp with time zone,
    employee_id integer,
    notes text
);


ALTER TABLE public.jcitems OWNER TO postgres;

--
-- Name: language; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE language (
    code character varying(6),
    description text
);


ALTER TABLE public.language OWNER TO postgres;

--
-- Name: makemodel; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE makemodel (
    parts_id integer,
    make text,
    model text
);


ALTER TABLE public.makemodel OWNER TO postgres;

--
-- Name: oe; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE oe (
    id integer DEFAULT nextval('id'::regclass),
    ordnumber text,
    transdate date DEFAULT ('now'::text)::date,
    vendor_id integer,
    customer_id integer,
    amount double precision,
    netamount double precision,
    reqdate date,
    taxincluded boolean,
    shippingpoint text,
    notes text,
    curr character(3),
    employee_id integer,
    closed boolean DEFAULT false,
    quotation boolean DEFAULT false,
    quonumber text,
    intnotes text,
    department_id integer DEFAULT 0,
    shipvia text,
    language_code character varying(6),
    ponumber text,
    terms smallint DEFAULT 0,
    waybill text,
    warehouse_id integer,
    description text,
    aa_id integer,
    exchangerate double precision,
    ticket_id integer
);


ALTER TABLE public.oe OWNER TO postgres;

--
-- Name: orderitemsid; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE orderitemsid
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.orderitemsid OWNER TO postgres;

--
-- Name: orderitemsid; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('orderitemsid', 112, true);


--
-- Name: orderitems; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE orderitems (
    id integer DEFAULT nextval('orderitemsid'::regclass),
    trans_id integer,
    parts_id integer,
    description text,
    qty double precision,
    sellprice double precision,
    discount real,
    unit character varying(5),
    project_id integer,
    reqdate date,
    ship double precision,
    serialnumber text,
    itemnotes text,
    lineitemdetail boolean,
    ordernumber text,
    ponumber text
);


ALTER TABLE public.orderitems OWNER TO postgres;

--
-- Name: parts; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE parts (
    id integer DEFAULT nextval('id'::regclass),
    partnumber text,
    description text,
    unit character varying(5),
    listprice double precision,
    sellprice double precision,
    lastcost double precision,
    priceupdate date DEFAULT ('now'::text)::date,
    weight double precision,
    onhand double precision DEFAULT 0,
    notes text,
    makemodel boolean DEFAULT false,
    assembly boolean DEFAULT false,
    alternate boolean DEFAULT false,
    rop double precision,
    inventory_accno_id integer,
    income_accno_id integer,
    expense_accno_id integer,
    bin text,
    obsolete boolean DEFAULT false,
    bom boolean DEFAULT false,
    image text,
    drawing text,
    microfiche text,
    partsgroup_id integer,
    project_id integer,
    avgcost double precision,
    tariff_hscode text,
    countryorigin text,
    barcode text,
    toolnumber text
);


ALTER TABLE public.parts OWNER TO postgres;

--
-- Name: partsattr; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE partsattr (
    parts_id integer,
    hotnew character(3)
);


ALTER TABLE public.partsattr OWNER TO postgres;

--
-- Name: partscustomer; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE partscustomer (
    parts_id integer,
    customer_id integer,
    pricegroup_id integer,
    pricebreak double precision,
    sellprice double precision,
    validfrom date,
    validto date,
    curr character(3)
);


ALTER TABLE public.partscustomer OWNER TO postgres;

--
-- Name: partsgroup; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE partsgroup (
    id integer DEFAULT nextval('id'::regclass),
    partsgroup text,
    pos boolean DEFAULT true
);


ALTER TABLE public.partsgroup OWNER TO postgres;

--
-- Name: partstax; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE partstax (
    parts_id integer,
    chart_id integer
);


ALTER TABLE public.partstax OWNER TO postgres;

--
-- Name: partsvendor; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE partsvendor (
    vendor_id integer,
    parts_id integer,
    partnumber text,
    leadtime smallint,
    lastcost double precision,
    curr character(3)
);


ALTER TABLE public.partsvendor OWNER TO postgres;

--
-- Name: payment; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE payment (
    id integer NOT NULL,
    trans_id integer NOT NULL,
    exchangerate double precision DEFAULT 1,
    paymentmethod_id integer
);


ALTER TABLE public.payment OWNER TO postgres;

--
-- Name: paymentmethod; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE paymentmethod (
    id integer DEFAULT nextval('id'::regclass) NOT NULL,
    description text,
    fee double precision,
    rn integer
);


ALTER TABLE public.paymentmethod OWNER TO postgres;

--
-- Name: pricegroup; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE pricegroup (
    id integer DEFAULT nextval('id'::regclass),
    pricegroup text
);


ALTER TABLE public.pricegroup OWNER TO postgres;

--
-- Name: project; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE project (
    id integer DEFAULT nextval('id'::regclass),
    projectnumber text,
    description text,
    startdate date,
    enddate date,
    parts_id integer,
    production double precision DEFAULT 0,
    completed double precision DEFAULT 0,
    customer_id integer
);


ALTER TABLE public.project OWNER TO postgres;

--
-- Name: recurring; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE recurring (
    id integer,
    reference text,
    startdate date,
    nextdate date,
    enddate date,
    repeat smallint,
    unit character varying(6),
    howmany integer,
    payment boolean DEFAULT false,
    description text
);


ALTER TABLE public.recurring OWNER TO postgres;

--
-- Name: recurringemail; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE recurringemail (
    id integer,
    formname text,
    format text,
    message text
);


ALTER TABLE public.recurringemail OWNER TO postgres;

--
-- Name: recurringprint; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE recurringprint (
    id integer,
    formname text,
    format text,
    printer text
);


ALTER TABLE public.recurringprint OWNER TO postgres;

--
-- Name: report; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE report (
    reportid integer DEFAULT nextval('id'::regclass) NOT NULL,
    reportcode text,
    reportdescription text,
    login text
);


ALTER TABLE public.report OWNER TO postgres;

--
-- Name: reportvars; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE reportvars (
    reportid integer NOT NULL,
    reportvariable text,
    reportvalue text
);


ALTER TABLE public.reportvars OWNER TO postgres;

--
-- Name: semaphore; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE semaphore (
    id integer,
    login text,
    module text,
    expires character varying(10)
);


ALTER TABLE public.semaphore OWNER TO postgres;

--
-- Name: shipto; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE shipto (
    trans_id integer,
    shiptoname character varying(64),
    shiptoaddress1 character varying(32),
    shiptoaddress2 character varying(32),
    shiptocity character varying(32),
    shiptostate character varying(32),
    shiptozipcode character varying(10),
    shiptocountry character varying(32),
    shiptocontact character varying(64),
    shiptophone character varying(20),
    shiptofax character varying(20),
    shiptoemail text
);


ALTER TABLE public.shipto OWNER TO postgres;

--
-- Name: sic; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE sic (
    code character varying(6),
    sictype character(1),
    description text
);


ALTER TABLE public.sic OWNER TO postgres;

--
-- Name: status; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE status (
    trans_id integer,
    formname text,
    printed boolean DEFAULT false,
    emailed boolean DEFAULT false,
    spoolfile text
);


ALTER TABLE public.status OWNER TO postgres;

--
-- Name: tax; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE tax (
    chart_id integer,
    rate double precision,
    taxnumber text,
    validto date
);


ALTER TABLE public.tax OWNER TO postgres;

--
-- Name: translation; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE translation (
    trans_id integer,
    language_code character varying(6),
    description text
);


ALTER TABLE public.translation OWNER TO postgres;

--
-- Name: trf; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE trf (
    id integer DEFAULT nextval(('id'::text)::regclass) NOT NULL,
    transdate date,
    trfnumber text,
    description text,
    notes text,
    department_id integer,
    from_warehouse_id integer,
    to_warehouse_id integer DEFAULT 0,
    employee_id integer DEFAULT 0,
    delivereddate date,
    ticket_id integer
);


ALTER TABLE public.trf OWNER TO postgres;

--
-- Name: vendor; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE vendor (
    id integer DEFAULT nextval('id'::regclass) NOT NULL,
    name character varying(64),
    contact character varying(64),
    phone character varying(20),
    fax character varying(20),
    email text,
    notes text,
    terms smallint DEFAULT 0,
    taxincluded boolean DEFAULT false,
    vendornumber character varying(32),
    cc text,
    bcc text,
    gifi_accno character varying(30),
    business_id integer,
    taxnumber character varying(32),
    sic_code character varying(6),
    discount real,
    creditlimit double precision DEFAULT 0,
    iban character varying(34),
    bic character varying(11),
    employee_id integer,
    language_code character varying(6),
    pricegroup_id integer,
    curr character(3),
    startdate date,
    enddate date,
    arap_accno_id integer,
    payment_accno_id integer,
    discount_accno_id integer,
    cashdiscount real,
    discountterms smallint,
    threshold double precision,
    paymentmethod_id integer,
    remittancevoucher boolean
);


ALTER TABLE public.vendor OWNER TO postgres;

--
-- Name: vendortax; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE vendortax (
    vendor_id integer,
    chart_id integer
);


ALTER TABLE public.vendortax OWNER TO postgres;

--
-- Name: vr; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE vr (
    br_id integer,
    trans_id integer NOT NULL,
    id integer DEFAULT nextval('id'::regclass) NOT NULL,
    vouchernumber text
);


ALTER TABLE public.vr OWNER TO postgres;

--
-- Name: warehouse; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE warehouse (
    id integer DEFAULT nextval('id'::regclass),
    description text
);


ALTER TABLE public.warehouse OWNER TO postgres;

--
-- Name: yearend; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE yearend (
    trans_id integer,
    transdate date
);


ALTER TABLE public.yearend OWNER TO postgres;

--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE customerlogin ALTER COLUMN id SET DEFAULT nextval('customerlogin_id_seq'::regclass);


--
-- Data for Name: acc_trans; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY acc_trans (trans_id, chart_id, amount, transdate, source, approved, fx_transaction, project_id, memo, id, cleared, vr_id, entry_id) FROM stdin;
10143	10017	-6000	2007-07-01		t	f	\N		\N	\N	\N	2
10143	10034	6000	2007-07-01		t	f	\N		\N	\N	\N	3
10142	10017	-10000	2007-07-01	1234	t	f	\N		\N	\N	\N	4
10142	10034	10000	2007-07-01	1234	t	f	\N		\N	\N	\N	5
10153	10006	-234	2007-07-12		t	f	\N		\N	\N	\N	6
10153	10017	234	2007-07-12		t	f	\N		\N	\N	\N	7
10154	10017	250	2007-07-12		t	f	\N		\N	\N	\N	8
10154	10068	-250	2007-07-12		t	f	\N		\N	\N	\N	9
10148	10038	119.92	2007-07-06	\N	t	f	\N	\N	57	\N	\N	10
10148	10038	71.879999999999995	2007-07-06	\N	t	f	\N	\N	58	\N	\N	11
10148	10014	-225.37	2007-07-06	\N	t	f	\N	\N	\N	\N	\N	12
10148	10025	33.57	2007-07-06	\N	t	f	\N	\N	\N	\N	\N	13
10148	10014	225.37	2007-07-12	\N	t	f	\N	\N	\N	\N	\N	14
10148	10017	-225.37	2007-07-12	8712	t	f	\N		1	\N	\N	15
10149	10038	900	2007-07-06	\N	t	f	10159	\N	89	\N	\N	37
10149	10038	400	2007-07-06	\N	t	f	10161	\N	90	\N	\N	38
10149	10014	-1592.5	2007-07-06	\N	t	f	\N	\N	\N	\N	\N	39
10149	10026	65	2007-07-06	\N	t	f	\N	\N	\N	\N	\N	40
10149	10025	227.5	2007-07-06	\N	t	f	\N	\N	\N	\N	\N	41
10149	10014	1000	2007-07-12	\N	t	f	\N	\N	\N	\N	\N	42
10149	10017	-1000	2007-07-12	8712	t	f	\N		1	\N	\N	43
10150	10038	89.950000000000003	2007-07-09	\N	t	f	\N	\N	91	\N	\N	44
10150	10038	59.960000000000001	2007-07-09	\N	t	f	\N	\N	93	\N	\N	46
10150	10038	56.969999999999999	2007-07-09	\N	t	f	\N	\N	92	\N	\N	47
10150	10014	-250.43000000000001	2007-07-09	\N	t	f	\N	\N	\N	\N	\N	55
10150	10026	7.3499999999999996	2007-07-09	\N	t	f	\N	\N	\N	\N	\N	56
10150	10025	36.200000000000003	2007-07-09	\N	t	f	\N	\N	\N	\N	\N	57
10151	10038	56.969999999999999	2007-07-12	\N	t	f	\N	\N	94	\N	\N	58
10151	10038	44.969999999999999	2007-07-12	\N	t	f	\N	\N	95	\N	\N	60
10151	10014	-122.63	2007-07-12	\N	t	f	\N	\N	\N	\N	\N	64
10151	10026	2.8500000000000001	2007-07-12	\N	t	f	\N	\N	\N	\N	\N	65
10151	10025	17.84	2007-07-12	\N	t	f	\N	\N	\N	\N	\N	66
10152	10038	149.94	2007-07-12	\N	t	f	\N	\N	99	\N	\N	67
10152	10038	74.969999999999999	2007-07-12	\N	t	f	\N	\N	101	\N	\N	69
10152	10038	44.969999999999999	2007-07-12	\N	t	f	\N	\N	100	\N	\N	71
10152	10014	-317.11000000000001	2007-07-12	\N	t	f	\N	\N	\N	\N	\N	76
10152	10025	47.229999999999997	2007-07-12	\N	t	f	\N	\N	\N	\N	\N	77
10144	10012	-16.989999999999998	2007-07-01	\N	t	f	\N	\N	106	\N	\N	120
10144	10012	-16	2007-07-01	\N	t	f	\N	\N	105	\N	\N	121
10144	10022	40.409999999999997	2007-07-01	\N	t	f	\N	\N	\N	\N	\N	122
10144	10026	-1.6499999999999999	2007-07-01	\N	t	f	\N	\N	\N	\N	\N	123
10144	10025	-5.7699999999999996	2007-07-01	\N	t	f	\N	\N	\N	\N	\N	124
10145	10012	-672	2007-07-03	\N	t	f	\N	\N	107	\N	\N	141
10145	10012	-494.5	2007-07-03	\N	t	f	\N	\N	110	\N	\N	142
10145	10012	-322.82999999999998	2007-07-03	\N	t	f	\N	\N	108	\N	\N	143
10145	10012	-251.78999999999999	2007-07-03	\N	t	f	\N	\N	109	\N	\N	144
10145	10022	2045.8199999999999	2007-07-03	\N	t	f	\N	\N	\N	\N	\N	145
10145	10025	-304.69999999999999	2007-07-03	\N	t	f	\N	\N	\N	\N	\N	146
10145	10022	-2000	2007-07-13	\N	t	f	\N	\N	\N	\N	\N	147
10145	10017	2000	2007-07-13	6762	t	f	\N		1	\N	\N	148
10147	10038	113.94	2007-07-05	\N	t	f	10159	\N	121	\N	\N	175
10147	10038	44.969999999999999	2007-07-05	\N	t	f	10160	\N	122	\N	\N	177
10147	10014	-192.41999999999999	2007-07-05	\N	t	f	\N	\N	\N	\N	\N	181
10147	10026	5.7000000000000002	2007-07-05	\N	t	f	\N	\N	\N	\N	\N	182
10147	10025	27.809999999999999	2007-07-05	\N	t	f	\N	\N	\N	\N	\N	183
10141	10012	-509.69999999999999	2007-07-01	\N	t	f	10159	\N	123	\N	\N	228
10141	10012	-444	2007-07-01	\N	t	f	10160	\N	124	\N	\N	229
10141	10012	-239.25	2007-07-01	\N	t	f	10161	\N	125	\N	\N	230
10141	10022	1427.21	2007-07-01	\N	t	f	\N	\N	\N	\N	\N	231
10141	10026	-25.489999999999998	2007-07-01	\N	t	f	\N	\N	\N	\N	\N	232
10141	10025	-208.77000000000001	2007-07-01	\N	t	f	\N	\N	\N	\N	\N	233
10146	10012	-21.5	2007-07-12	\N	t	f	\N	\N	127	\N	\N	234
10146	10012	-11.99	2007-07-12	\N	t	f	\N	\N	126	\N	\N	235
10146	10022	39.350000000000001	2007-07-12	\N	t	f	\N	\N	\N	\N	\N	236
10146	10025	-5.8600000000000003	2007-07-12	\N	t	f	\N	\N	\N	\N	\N	237
10150	10012	64	2007-07-09	cogs	t	f	\N	\N	107	\N	\N	238
10150	10045	-64	2007-07-09	cogs	t	f	\N	\N	107	\N	\N	239
10150	10012	16	2007-07-09	cogs	t	f	\N	\N	105	\N	\N	240
10150	10045	-16	2007-07-09	cogs	t	f	\N	\N	105	\N	\N	241
10152	10012	113.94	2007-07-12	cogs	t	f	\N	\N	108	\N	\N	242
10152	10045	-113.94	2007-07-12	cogs	t	f	\N	\N	108	\N	\N	243
10152	10012	35.969999999999999	2007-07-12	cogs	t	f	\N	\N	109	\N	\N	244
10152	10045	-35.969999999999999	2007-07-12	cogs	t	f	\N	\N	109	\N	\N	245
10152	10012	64.5	2007-07-12	cogs	t	f	\N	\N	110	\N	\N	246
10152	10045	-64.5	2007-07-12	cogs	t	f	\N	\N	110	\N	\N	247
10151	10012	50.969999999999999	2007-07-12	cogs	t	f	\N	\N	123	\N	\N	250
10151	10045	-50.969999999999999	2007-07-12	cogs	t	f	\N	\N	123	\N	\N	251
10150	10012	50.969999999999999	2007-07-09	cogs	t	f	\N	\N	123	\N	\N	252
10150	10045	-50.969999999999999	2007-07-09	cogs	t	f	\N	\N	123	\N	\N	253
10147	10012	101.94	2007-07-05	cogs	t	f	\N	\N	123	\N	\N	254
10147	10045	-101.94	2007-07-05	cogs	t	f	\N	\N	123	\N	\N	255
10151	10012	36	2007-07-12	cogs	t	f	\N	\N	124	\N	\N	258
10151	10045	-36	2007-07-12	cogs	t	f	\N	\N	124	\N	\N	259
10150	10012	48	2007-07-09	cogs	t	f	\N	\N	124	\N	\N	260
10150	10045	-48	2007-07-09	cogs	t	f	\N	\N	124	\N	\N	261
10148	10012	96	2007-07-06	cogs	t	f	\N	\N	124	\N	\N	262
10148	10045	-96	2007-07-06	cogs	t	f	\N	\N	124	\N	\N	263
10147	10012	36	2007-07-05	cogs	t	f	\N	\N	124	\N	\N	264
10147	10045	-36	2007-07-05	cogs	t	f	\N	\N	124	\N	\N	265
10148	10012	52.200000000000003	2007-07-06	cogs	t	f	\N	\N	125	\N	\N	268
10148	10045	-52.200000000000003	2007-07-06	cogs	t	f	\N	\N	125	\N	\N	269
10243	10038	17.989999999999998	2011-04-11	\N	t	f	\N	\N	130	\N	\N	274
10243	10012	16	2011-04-11	\N	t	f	\N	\N	107	\N	\N	275
10243	10045	-16	2011-04-11	\N	t	f	\N	\N	107	\N	\N	276
10243	10014	-17.989999999999998	2011-04-11	\N	t	f	\N	\N	\N	\N	\N	277
\.


--
-- Data for Name: address; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY address (id, trans_id, address1, address2, city, state, zipcode, country) FROM stdin;
16	10132			London		AA7 9BB	UK
17	10134						
18	10135						
13	10129			London		AA7 9BB	UK
12	10128			London		AA7 9BB	UK
3	10119			London			UK
6	10122			London		AA7 9BB	UK
5	10121			London		AA7 9BB	UK
4	10120			London			UK
9	10125			London		AA7 9BB	UK
14	10130			London		AA7 9BB	UK
15	10131			London		AA7 9BB	UK
19	\N	31-2nd Floor, Hafeez Center	Main Blvd, Gulberg III	Lahore	Punjab	54600	Pakistan
2	10118			London		AA7 9BB	UK
65	10238						
66	10239						
64	10237	na	na	na	na	na	na
\.


--
-- Data for Name: ap; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY ap (id, invnumber, transdate, vendor_id, taxincluded, amount, netamount, paid, datepaid, duedate, invoice, ordnumber, curr, notes, employee_id, till, quonumber, intnotes, department_id, shipvia, language_code, ponumber, shippingpoint, terms, approved, cashdiscount, discountterms, waybill, warehouse_id, description, onhold, exchangerate, dcn, bank_id, paymentmethod_id, ticket_id) FROM stdin;
10144	AP-002	2007-07-01	10131	f	40.409999999999997	32.990000000000002	0	\N	2007-07-01	t		GBP		10102	\N			10136					0	t	0	0		10134		f	1		10017	0	\N
10145	AP-003	2007-07-03	10132	f	2045.8199999999999	1741.1199999999999	2000	2007-07-13	2007-07-05	t		GBP		10102	\N			10136					0	t	0	0		10134		f	1		10017	0	\N
10141	AP-001	2007-07-01	10130	f	1427.21	1192.95	0	\N	2007-07-10	t		GBP		10102	\N			10136					9	t	0	0		10134		f	1		10017	0	\N
10146	AP-004	2007-07-12	10132	f	39.350000000000001	33.490000000000002	0	\N	2007-07-12	t		GBP		10102	\N			10136					0	t	0	0		10135		f	1		10017	0	\N
\.


--
-- Data for Name: ar; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY ar (id, invnumber, transdate, customer_id, taxincluded, amount, netamount, paid, datepaid, duedate, invoice, shippingpoint, terms, notes, curr, ordnumber, employee_id, till, quonumber, intnotes, department_id, shipvia, language_code, ponumber, approved, cashdiscount, discountterms, waybill, warehouse_id, description, onhold, exchangerate, dcn, bank_id, paymentmethod_id, ticket_id) FROM stdin;
10148	AR-002	2007-07-06	10128	f	225.37	191.80000000000001	225.37	2007-07-12	2007-07-06	t		0		GBP		10102	\N			10136				t	0	0		10134		f	1		10017	0	\N
10149	AR-003	2007-07-06	10128	f	1592.5	1300	1000	2007-07-12	2007-07-06	t		0		GBP		10102	\N			10137				t	0	0		10134		f	1		10017	0	\N
10150	AR-004	2007-07-09	10119	f	250.43000000000001	206.88	0	\N	2007-07-10	t		1		GBP		10102	\N			10136				t	0	0		10134		f	1		10017	0	\N
10151	AR-005	2007-07-12	10121	f	122.63	101.94	0	\N	2007-07-12	t		0		GBP		10102	\N			10136				t	0	0		10134		f	1		10017	0	\N
10152	AR-006	2007-07-12	10125	f	317.11000000000001	269.88	0	\N	2007-07-12	t		0		GBP		10102	\N			10136				t	0	0		10134		f	1		10017	0	\N
10147	AR-001	2007-07-05	10118	f	192.41999999999999	158.91	0	\N	2007-07-05	t		0		GBP		10102	\N			10136				t	0	0		10134		f	1		10017	0	\N
10243	AR-012	2011-04-11	10237	f	17.989999999999998	17.989999999999998	0	\N	2011-04-11	t		0		GBP	SO-029	10236	\N			10136				t	0	0		10134		f	1		10017	0	\N
\.


--
-- Data for Name: assembly; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY assembly (id, parts_id, qty, bom, adj, aid) FROM stdin;
2	10115	3	f	t	10156
3	10110	1	f	t	10156
4	10112	2	f	t	10156
\.


--
-- Data for Name: audittrail; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY audittrail (trans_id, tablename, reference, formname, action, transdate, employee_id) FROM stdin;
\.


--
-- Data for Name: bank; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY bank (id, name, iban, bic, address_id, dcn, rvc, membernumber) FROM stdin;
\.


--
-- Data for Name: br; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY br (id, batchnumber, description, batch, transdate, apprdate, amount, managerid, employee_id) FROM stdin;
\.


--
-- Data for Name: build; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY build (id, reference, transdate, department_id, warehouse_id, employee_id) FROM stdin;
\.


--
-- Data for Name: business; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY business (id, description, discount) FROM stdin;
\.


--
-- Data for Name: cargo; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY cargo (id, trans_id, package, netweight, grossweight, volume) FROM stdin;
\.


--
-- Data for Name: chart; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY chart (id, accno, description, charttype, category, link, gifi_accno, contra) FROM stdin;
10001	0010	Freehold Property	A	A			f
10002	0011	Goodwill	A	A			f
10003	0012	Goodwill Amortisation	A	A			f
10004	0020	Plant and Machinery	A	A			f
10005	0021	Plant/Machinery Depreciation	A	A			t
10006	0030	Office Equipment	A	A			f
10007	0031	Office Equipment Depreciation	A	A			t
10008	0040	Furniture and Fixtures	A	A			f
10009	0041	Furniture/Fixture Depreciation	A	A			t
10010	0050	Motor Vehicles	A	A			f
10011	0051	Motor Vehicles Depreciation	A	A			t
10012	1001	Stock	A	A	IC		f
10013	1002	Work in Progress	A	A	IC		f
10014	1100	Debtors Control Account	A	A	AR		f
10015	1102	Other Debtors	A	A	AR		f
10016	1103	Prepayments	A	A			f
10017	1200	Bank Current Account	A	A	AR_paid:AP_paid		f
10018	1210	Bank Deposit Account	A	A			f
10019	1220	Building Society Account	A	A			f
10020	1230	Petty Cash	A	A	AR_paid:AP_paid		f
10021	1240	Company Credit Card	A	L			f
10022	2100	Creditors Control Account	A	L	AP		f
10023	2102	Other Creditors	A	L	AP		f
10024	2109	Accruals	A	L			f
10025	2200	VAT (17.5%)	A	L	AR_tax:AP_tax:IC_taxpart:IC_taxservice		f
10026	2205	VAT (5%)	A	L	AR_tax:AP_tax:IC_taxpart:IC_taxservice		f
10027	2210	P.A.Y.E. & National Insurance	A	L			f
10028	2220	Net Wages	A	L			f
10029	2250	Corporation Tax	A	L			f
10030	2300	Bank Loan	A	L			f
10031	2305	Directors loan account	A	L			f
10032	2310	Hire Purchase	A	L			f
10033	2330	Mortgages	A	L			f
10034	3000	Ordinary Shares	A	Q			f
10035	3010	Preference Shares	A	Q			f
10036	3100	Share Premium Account	A	Q			f
10037	3200	Profit and Loss Account	A	Q			f
10038	4000	Sales	A	I	AR_amount:IC_sale:IC_income		f
10039	4010	Export Sales	A	I	AR_amount:IC_sale:IC_income		f
10040	4009	Discounts Allowed	A	I			f
10041	4900	Miscellaneous Income	A	I	AR_amount:IC_sale:IC_income		f
10042	4904	Rent Income	A	I	AR_amount		f
10043	4906	Interest received	A	I	AR_amount		f
10044	4920	Foreign Exchange Gain	A	I			f
10045	5000	Materials Purchased	A	E	AP_amount:IC_cogs:IC_expense		f
10046	5001	Materials Imported	A	E	AP_amount:IC_cogs:IC_expense		f
10047	5002	Opening Stock	A	E			f
10048	5003	Closing Stock	A	E			f
10049	5200	Packaging	A	E	AP_amount		f
10050	5201	Discounts Taken	A	E			f
10051	5202	Carriage	A	E	AP_amount		f
10052	5203	Import Duty	A	E	AP_amount		f
10053	5204	Transport Insurance	A	E	AP_amount		f
10054	5205	Equipment Hire	A	E			f
10055	5220	Foreign Exchange Loss	A	E			f
10056	6000	Productive Labour	A	E	AP_amount		f
10057	6001	Cost of Sales Labour	A	E	AP_amount		f
10058	6002	Sub-Contractors	A	E	AP_amount		f
10059	7000	Staff wages & salaries	A	E	AP_amount		f
10060	7002	Directors Remuneration	A	E	AP_amount		f
10061	7006	Employers N.I.	A	E	AP_amount		f
10062	7007	Employers Pensions	A	E	AP_amount		f
10063	7008	Recruitment Expenses	A	E	AP_amount		f
10064	7100	Rent	A	E	AP_amount		f
10065	7102	Water Rates	A	E	AP_amount		f
10066	7103	General Rates	A	E	AP_amount		f
10067	7104	Premises Insurance	A	E	AP_amount		f
10068	7200	Light & heat	A	E	AP_amount		f
10069	7300	Motor expenses	A	E	AP_amount		f
10070	7350	Travelling	A	E	AP_amount		f
10071	7400	Advertising	A	E	AP_amount		f
10072	7402	P.R. (Literature & Brochures)	A	E	AP_amount		f
10073	7403	U.K. Entertainment	A	E	AP_amount		f
10074	7404	Overseas Entertainment	A	E	AP_amount		f
10075	7500	Postage and Carriage	A	E	AP_amount		f
10076	7501	Office Stationery	A	E	AP_amount		f
10077	7502	Telephone	A	E	AP_amount		f
10078	7506	Web Site costs	A	E	AP_amount		f
10079	7600	Legal Fees	A	E	AP_amount		f
10080	7601	Audit and Accountancy Fees	A	E	AP_amount		f
10081	7603	Professional Fees	A	E	AP_amount		f
10082	7701	Office Machine Maintenance	A	E	AP_amount		f
10083	7710	Computer expenses	A	E	AP_amount		f
10084	7800	Repairs and Renewals	A	E	AP_amount		f
10085	7801	Cleaning	A	E	AP_amount		f
10086	7802	Laundry	A	E	AP_amount		f
10087	7900	Bank Interest Paid	A	E			f
10088	7901	Bank Charges	A	E			f
10089	7903	Loan Interest Paid	A	E			f
10090	7904	H.P. Interest	A	E			f
10091	8000	Depreciation	A	E			f
10092	8005	Goodwill Amortisation	A	E			f
10093	8100	Bad Debt Write Off	A	E			f
10094	8201	Subscriptions	A	E	AP_amount		f
10095	8202	Clothing Costs	A	E	AP_amount		f
10096	8203	Training Costs	A	E	AP_amount		f
10097	8204	Insurance	A	E	AP_amount		f
10098	8205	Refreshments	A	E	AP_amount		f
10099	8500	Dividends	A	E			f
10100	8600	Corporation Tax	A	E			f
10101	9999	Suspense Account	A	E			f
\.


--
-- Data for Name: contact; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY contact (id, trans_id, salutation, firstname, lastname, contacttitle, occupation, phone, fax, mobile, email, gender, parent_id, typeofcontact) FROM stdin;
7	10123		Larry	Riley							M	\N	company
8	10124		Michele	Carter							M	\N	company
10	10126		Michael 								M	\N	company
11	10127		Steve	Smith							M	\N	company
16	10132		Michael	KIng							M	\N	company
13	10129										M	\N	company
12	10128		Milton	Bear							M	\N	company
3	10119	Mr.	John	King							M	\N	company
6	10122		Larry	Riley							M	\N	company
5	10121		Louis	Adams							M	\N	company
4	10120		Joseph	Rollins							M	\N	company
9	10125		Michael	Keller							M	\N	company
14	10130		Thomas	Lucas							M	\N	company
15	10131		John	King							M	\N	company
18	10163	\N	Maverick Solutions		\N	\N	0345-4300011	\N	\N	saqib@ledger123.com	M	\N	\N
19	10165	\N	Armaghan	Saqib	\N	\N	0345-4300011	\N	\N	saqib1@ledger123.com	M	\N	\N
21	10169	\N	Armaghan	Saqib	\N	\N	0345-4300011	\N	\N	saqib@ledger123.com3	M	\N	\N
22	10171	\N	Armaghan	Saqib	\N	\N	44332	\N	\N	saqib@ledger123.com4	M	\N	\N
23	10173	\N	Armaghan	Saqib	\N	\N	0345-4300011	\N	\N	saqib9@gmail.com	M	\N	\N
20	10167		Armaghan 	Saqib			1111			abc@dbf.com	M	\N	company
24	10175		Saqib	Awan			0345-4300011			sales@oledger.com	M	\N	company
25	10190	\N	a	a	\N	\N		\N	\N	support@ledger123.com	M	\N	\N
26	10195	\N	Saqib	Jee	\N	\N	\N	\N	\N	saqib@localhost	M	\N	\N
2	10118		Charles	Kirk						root@localhost	M	\N	company
27	10199	\N	Zahid	Khan	\N	\N	\N	\N	\N	zahid.h.khan@gmail.com	M	\N	\N
28	10200	\N	Zahid	Khan	\N	\N	\N	\N	\N	zahid.h.khan@gmail.com	M	\N	\N
29	10202	\N	Armaghan Saqib Awan	Awan	\N	\N	\N	\N	\N	mail@armaghansaqib.com	M	\N	\N
63	10238		Sebastian	Weitmann							M	\N	company
64	10239		Rolf	Stöckli							M	\N	company
62	10237		Thomas	Brändle						ar.saqib@gmail.com	M	\N	company
\.


--
-- Data for Name: curr; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY curr (rn, curr, "precision") FROM stdin;
1	GBP	2
\.


--
-- Data for Name: customer; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY customer (id, name, contact, phone, fax, email, notes, terms, taxincluded, customernumber, cc, bcc, business_id, taxnumber, sic_code, discount, creditlimit, iban, bic, employee_id, language_code, pricegroup_id, curr, startdate, enddate, arap_accno_id, payment_accno_id, discount_accno_id, cashdiscount, discountterms, threshold, paymentmethod_id, remittancevoucher) FROM stdin;
10129	Automotive Ltd	 					0	f	AL012			0			0	0			10102		0	GBP	2007-04-29	\N	\N	\N	\N	0	0	0	0	f
10128	Big Porridge Ltd.	Milton Bear					0	f	BP011			0			0	0			10102		0	GBP	2007-04-29	\N	\N	\N	\N	0	0	0	0	f
10119	Car Parts Ltd	John King					0	f	CP002			0			0	0			10102		0	GBP	2007-04-29	\N	\N	\N	\N	0	0	0	0	f
10122	Computerz Ltd.	Larry Riley					0	f	CL005			0			0	500			10102		0	GBP	2007-04-29	\N	\N	\N	\N	0	0	0	0	f
10121	Electronics Ltd.	Louis Adams					0	f	EL004			0			0	0			10102		0	GBP	2007-04-29	\N	\N	\N	\N	0	0	0	0	f
10120	Expert Repair Ltd	Joseph Rollins					0	f	ER003			0			0	0			10102		0	GBP	2007-04-29	\N	\N	\N	\N	0	0	0	0	f
10125	InfoMed Ltd.	Michael Keller					0	f	IL008			0			0	0			10102		0	GBP	2007-04-29	\N	\N	\N	\N	0	0	0	0	f
10118	Auto Exchange Express	Charles Kirk			root@localhost		0	f	AE001			0			0	1500			10102		0	GBP	2007-04-29	\N	10014	10017	\N	0	0	0	0	f
10239	tokon	Rolf Stöckli			info@tokon.net		0	f	T028			0			0	0			10236		0	GBP	2011-04-11	\N	\N	\N	\N	0	0	0	0	f
10238	runmyaccounts	Thomas Brändle			tbraendle@runmyaccounts.com		0	f	E027			0			0	0			10236		0	GBP	2011-04-11	\N	\N	\N	\N	0	0	0	0	f
10237	e-accountant	Sebastian Weitmann			sweitmann@e-accountant.de		0	f	TB026			0			0	0			10236		0	GBP	2011-04-11	\N	\N	\N	\N	0	0	0	0	f
\.


--
-- Data for Name: customercart; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY customercart (cart_id, customer_id, parts_id, qty, price, taxaccounts) FROM stdin;
1f88a47b5656a60cde315be042e873f2	0	10115	1	17.989999999999998	2200 2205
\.


--
-- Data for Name: customerlogin; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY customerlogin (id, login, passwd, session, session_exp, customer_id) FROM stdin;
1	sweitmann@e-accountant.de	390efd79fa5bb99c9ba2d7b35c37e041	dddf9140e1cd2a0aaf59cf1b131967ce	2011-4-14-5-46-48	10237
\.


--
-- Data for Name: customertax; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY customertax (customer_id, chart_id) FROM stdin;
10129	10025
10129	10026
10128	10025
10128	10026
10119	10025
10119	10026
10122	10025
10122	10026
10121	10025
10121	10026
10120	10025
10120	10026
10125	10025
10125	10026
10118	10025
10118	10026
\.


--
-- Data for Name: defaults; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY defaults (fldname, fldvalue) FROM stdin;
inventory_accno_id	10012
income_accno_id	10038
expense_accno_id	10045
fxgain_accno_id	10044
fxloss_accno_id	10055
batchnumber	BATCH-000
vouchernumber	V-000
ponumber	PO-000
sqnumber	SO-000
rfqnumber	RFQ-000
partnumber	<%description 1%>010
projectnumber	
weightunit	kg
employeenumber	E-001
vendornumber	<%name 1 1%>003
vinumber	AP-004
glnumber	GL-004
precision	2
version	2.8.10
customernumber	<%name 1 1%>028
sonumber	SO-030
sinumber	AR-012
\.


--
-- Data for Name: department; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY department (id, description, role) FROM stdin;
10136	HARDWARE	P
10137	SERVICES	P
\.


--
-- Data for Name: dpt_trans; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY dpt_trans (trans_id, department_id) FROM stdin;
10142	10136
10148	10136
10149	10137
10150	10136
10151	10136
10152	10136
10144	10136
10145	10136
10162	10136
10179	10136
10176	10136
10180	10136
10188	10136
10189	10136
10147	10136
10141	10136
10146	10136
10198	10136
10243	10136
\.


--
-- Data for Name: employee; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY employee (id, login, name, address1, address2, city, state, zipcode, country, workphone, workfax, workmobile, homephone, startdate, enddate, notes, role, sales, email, ssn, iban, bic, managerid, employeenumber, dob) FROM stdin;
10133	ukdemo	Armaghan Saqib	\N	\N	\N	\N	\N	\N			\N	\N	2007-06-01	\N	\N	admin	t	mavsol@gmail.com	\N	\N	\N	\N	\N	\N
10102	armaghan	Armaghan Saqib								armaghan			2007-04-28	\N		admin	t					0	E-001	\N
10236	ledgercart		\N	\N	\N	\N	\N	\N			\N	\N	2011-04-11	\N	\N	user	t		\N	\N	\N	\N	\N	\N
\.


--
-- Data for Name: exchangerate; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY exchangerate (curr, transdate, buy, sell) FROM stdin;
\.


--
-- Data for Name: fifo; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY fifo (trans_id, transdate, parts_id, qty, costprice, sellprice, warehouse_id, invoice_id) FROM stdin;
10150	2007-07-09	10115	1	16	17.989999999999998	0	105
10150	2007-07-09	10115	4	16	17.989999999999998	0	107
10152	2007-07-12	10111	6	18.989999999999998	24.989999999999998	0	108
10152	2007-07-12	10112	3	11.99	14.99	0	109
10152	2007-07-12	10113	3	21.5	24.989999999999998	0	110
10147	2007-07-05	10116	6	16.989999999999998	18.989999999999998	0	123
10150	2007-07-09	10116	3	16.989999999999998	18.989999999999998	0	123
10151	2007-07-12	10116	3	16.989999999999998	18.989999999999998	0	123
10180	2010-06-05	10116	1	16.989999999999998	18.989999999999998	0	123
10147	2007-07-05	10117	3	12	14.99	0	124
10148	2007-07-06	10117	8	12	14.99	0	124
10150	2007-07-09	10117	4	12	14.99	0	124
10151	2007-07-12	10117	3	12	14.99	0	124
10180	2010-06-05	10117	2	12	14.99	0	124
10148	2007-07-06	10109	12	4.3499999999999996	5.9900000000000002	0	125
10180	2010-06-05	10109	1	4.3499999999999996	5.9900000000000002	0	125
\.


--
-- Data for Name: gifi; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY gifi (accno, description) FROM stdin;
\.


--
-- Data for Name: gl; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY gl (id, reference, description, transdate, employee_id, notes, department_id, approved, curr, exchangerate, ticket_id) FROM stdin;
10143	GL-002	Initial investment (ordinary shares)	2007-07-01	10133		0	t	GBP	1	\N
10142	GL-001	Initial investment	2007-07-01	10133		10136	t	GBP	1	\N
10153	GL-003	Office equipment purchased	2007-07-12	10133		0	t	GBP	1	\N
10154	GL-004	Paid bill for light and heating system	2007-07-12	10133		0	t	GBP	1	\N
\.


--
-- Data for Name: inventory; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY inventory (id, warehouse_id, parts_id, trans_id, orderitems_id, qty, shippingdate, employee_id, department_id, warehouse_id2, serialnumber, itemnotes, cost, linetype, description, invoice_id, cogs) FROM stdin;
27	10135	10116	10157	\N	2	2009-03-25	10102	10136	10134			16.989999999999998	1	Digger Hand Trencher	\N	\N
28	10134	10116	10157	\N	-2	2009-03-25	10102	10136	10135			16.989999999999998	2	Digger Hand Trencher	\N	\N
29	10135	10109	10157	\N	3	2009-03-25	10102	10136	10134			4.3499999999999996	1	Hand Brush	\N	\N
30	10134	10109	10157	\N	-3	2009-03-25	10102	10136	10135			4.3499999999999996	2	Hand Brush	\N	\N
31	10135	10117	10158	\N	4	2009-03-25	10102	10136	10134			12	1	The Claw Hand Rake	\N	\N
32	10134	10117	10158	\N	-4	2009-03-25	10102	10136	10135			12	2	The Claw Hand Rake	\N	\N
4	10134	10117	10148	1	-8	2007-07-06	10102	10136	\N			\N	0	\N	\N	0
5	10134	10109	10148	1	-12	2007-07-06	10102	10136	\N			\N	0	\N	\N	0
42	10134	10139	10149	1	-600	2007-07-06	10102	10137	\N			\N	0	Cleaning	89	0
43	10134	10140	10149	1	-200	2007-07-06	10102	10137	\N			\N	0	Wall Paint	90	0
66	0	10139	10178	29	-1	2010-06-04	10102	0	\N	\N	\N	\N	0	\N	\N	0
67	0	10140	10178	30	-2	2010-06-04	10102	0	\N	\N	\N	\N	0	\N	\N	0
68	0	10109	10177	34	-1	2010-06-04	10102	0	\N	\N	\N	\N	0	\N	\N	0
69	0	10116	10177	35	-1	2010-06-04	10102	0	\N	\N	\N	\N	0	\N	\N	0
70	0	10117	10177	36	-2	2010-06-04	10102	0	\N	\N	\N	\N	0	\N	\N	0
71	0	10108	10177	37	-1	2010-06-04	10102	0	\N	\N	\N	\N	0	\N	\N	0
72	10134	10139	10188	1	-10	2010-06-10	10102	10136	\N			\N	0	Cleaning	119	0
73	10134	10139	10189	1	-15	2010-06-11	10102	10136	\N			\N	0	Cleaning	120	0
58	10134	10115	10144	1	1	2007-07-01	10102	10136	\N			16	0	Deluxe Hand Saw	105	16
60	10134	10115	10145	1	42	2007-07-03	10102	10136	\N			16	0	Deluxe Hand Saw	107	672
44	10134	10115	10150	1	-5	2007-07-09	10102	10136	\N			16	0	Deluxe Hand Saw	91	-80
61	10134	10111	10145	1	17	2007-07-03	10102	10136	\N			18.989999999999998	0	Mini-Sledge	108	322.82999999999998
52	10134	10111	10152	1	-6	2007-07-12	10102	10136	\N			18.989999999999998	0	Mini-Sledge	99	-113.94
62	10134	10112	10145	1	21	2007-07-03	10102	10136	\N			11.99	0	Modeling Hammer	109	251.78999999999999
53	10134	10112	10152	1	-3	2007-07-12	10102	10136	\N			11.99	0	Modeling Hammer	100	-35.969999999999999
79	10135	10112	10146	1	1	2007-07-12	10102	10136	\N			11.99	0	Modeling Hammer	126	11.99
63	10134	10113	10145	1	23	2007-07-03	10102	10136	\N			21.5	0	Rubber Mallet	110	494.5
54	10134	10113	10152	1	-3	2007-07-12	10102	10136	\N			21.5	0	Rubber Mallet	101	-64.5
80	10135	10113	10146	1	1	2007-07-12	10102	10136	\N			21.5	0	Rubber Mallet	127	21.5
76	10134	10116	10141	1	30	2007-07-01	10102	10136	\N			16.989999999999998	0	Digger Hand Trencher	123	509.69999999999999
74	10134	10116	10147	1	-6	2007-07-05	10102	10136	\N			16.989999999999998	0	Digger Hand Trencher	121	-101.94
45	10134	10116	10150	1	-3	2007-07-09	10102	10136	\N			16.989999999999998	0	Digger Hand Trencher	92	-50.969999999999999
47	10134	10116	10151	1	-3	2007-07-12	10102	10136	\N			16.989999999999998	0	Digger Hand Trencher	94	-50.969999999999999
59	10134	10116	10144	1	1	2007-07-01	10102	10136	\N			16.989999999999998	0	Digger Hand Trencher	106	16.989999999999998
77	10134	10117	10141	1	37	2007-07-01	10102	10136	\N			12	0	The Claw Hand Rake	124	444
75	10134	10117	10147	1	-3	2007-07-05	10102	10136	\N			12	0	The Claw Hand Rake	122	-36
46	10134	10117	10150	1	-4	2007-07-09	10102	10136	\N			12	0	The Claw Hand Rake	93	-48
48	10134	10117	10151	1	-3	2007-07-12	10102	10136	\N			12	0	The Claw Hand Rake	95	-36
78	10134	10109	10141	1	55	2007-07-01	10102	10136	\N			4.3499999999999996	0	Hand Brush	125	239.25
81	0	10139	10197	67	-1	2010-06-22	10102	0	\N	\N	\N	\N	0	\N	\N	\N
82	0	10140	10197	68	-2	2010-06-22	10102	0	\N	\N	\N	\N	0	\N	\N	\N
83	10134	10115	10241	112	-1	2011-04-11	10236	0	\N	\N	\N	\N	0	\N	\N	\N
\.


--
-- Data for Name: invoice; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY invoice (id, trans_id, parts_id, description, qty, allocated, sellprice, fxsellprice, discount, assemblyitem, unit, project_id, deliverydate, serialnumber, itemnotes, lineitemdetail, transdate, lastcost, ordernumber, ponumber, warehouse_id, cogs) FROM stdin;
106	10144	10116	Digger Hand Trencher	-1	0	16.989999999999998	16.989999999999998	0	f	NOS	\N	\N			f	2007-07-01	16.989999999999998			10134	-16.989999999999998
122	10147	10117	The Claw Hand Rake	3	-3	14.99	14.99	0	f	NOS	10160	\N			t	2007-07-05	12			10134	36
57	10148	10117	The Claw Hand Rake	8	-8	14.99	14.99	0	f	NOS	\N	\N			f	2007-07-06	12	\N	\N	10134	96
93	10150	10117	The Claw Hand Rake	4	-4	14.99	14.99	0	f	NOS	\N	\N			f	2007-07-09	12			10134	48
95	10151	10117	The Claw Hand Rake	3	-3	14.99	14.99	0	f	NOS	\N	\N			f	2007-07-12	12			10134	36
126	10146	10112	Modeling Hammer	-1	0	11.99	11.99	0	f	NOS	\N	\N			f	2007-07-12	11.99			10135	-11.99
58	10148	10109	Hand Brush	12	-12	5.9900000000000002	5.9900000000000002	0	f	NOS	\N	\N			f	2007-07-06	4.3499999999999996	\N	\N	10134	52.200000000000003
127	10146	10113	Rubber Mallet	-1	0	21.5	21.5	0	f	NOS	\N	\N			f	2007-07-12	21.5			10135	-21.5
105	10144	10115	Deluxe Hand Saw	-1	1	16	16	0	f	NOS	\N	\N			f	2007-07-01	16			10134	-16
91	10150	10115	Deluxe Hand Saw	5	-5	17.989999999999998	17.989999999999998	0	f	NOS	\N	\N			f	2007-07-09	16			10134	80
108	10145	10111	Mini-Sledge	-17	6	18.989999999999998	18.989999999999998	0	f	NOS	\N	\N			f	2007-07-03	18.989999999999998			10134	-322.82999999999998
99	10152	10111	Mini-Sledge	6	-6	24.989999999999998	24.989999999999998	0	f	NOS	\N	\N			f	2007-07-12	18.989999999999998			10134	113.94
109	10145	10112	Modeling Hammer	-21	3	11.99	11.99	0	f	NOS	\N	\N			f	2007-07-03	11.99			10134	-251.78999999999999
100	10152	10112	Modeling Hammer	3	-3	14.99	14.99	0	f	NOS	\N	\N			f	2007-07-12	11.99			10134	35.969999999999999
110	10145	10113	Rubber Mallet	-23	3	21.5	21.5	0	f	NOS	\N	\N			f	2007-07-03	21.5			10134	-494.5
101	10152	10113	Rubber Mallet	3	-3	24.989999999999998	24.989999999999998	0	f	NOS	\N	\N			f	2007-07-12	21.5			10134	64.5
121	10147	10116	Digger Hand Trencher	6	-6	18.989999999999998	18.989999999999998	0	f	NOS	10159	\N			t	2007-07-05	16.989999999999998			10134	101.94
92	10150	10116	Digger Hand Trencher	3	-3	18.989999999999998	18.989999999999998	0	f	NOS	\N	\N			f	2007-07-09	16.989999999999998			10134	50.969999999999999
94	10151	10116	Digger Hand Trencher	3	-3	18.989999999999998	18.989999999999998	0	f	NOS	\N	\N			f	2007-07-12	16.989999999999998			10134	50.969999999999999
123	10141	10116	Digger Hand Trencher	-30	13	16.989999999999998	16.989999999999998	0	f	NOS	10159	\N			t	2007-07-01	16.989999999999998			10134	-509.69999999999993
90	10149	10140	Wall Paint	200	0	2	2	0	f	SQFT	10161	\N			t	2007-07-06	0			10134	0
89	10149	10139	Cleaning	600	0	1.5	1.5	0	f	SQFT	10159	\N			t	2007-07-06	0			10134	0
124	10141	10117	The Claw Hand Rake	-37	20	12	12	0	f	NOS	10160	\N			t	2007-07-01	12			10134	-444
125	10141	10109	Hand Brush	-55	13	4.3499999999999996	4.3499999999999996	0	f	NOS	10161	\N			t	2007-07-01	4.3499999999999996			10134	-239.24999999999997
107	10145	10115	Deluxe Hand Saw	-42	5	16	16	0	f	NOS	\N	\N			f	2007-07-03	16			10134	-672
130	10243	10115	Deluxe Hand Saw	1	-1	17.989999999999998	17.989999999999998	0	f	NOS	\N	\N			f	2011-04-11	\N			10134	\N
\.


--
-- Data for Name: invoicetax; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY invoicetax (trans_id, invoice_id, chart_id, taxamount) FROM stdin;
10150	65	10025	10.493
10150	64	10025	9.9697499999999994
10150	63	10025	15.741250000000001
10151	51	10025	7.8697499999999998
10151	50	10025	9.9697499999999994
10152	66	10025	26.2395
10152	67	10025	7.8697499999999998
10152	68	10025	13.11975
10149	61	10025	157.5
10149	62	10025	70
10148	57	10025	20.986000000000001
10148	58	10025	12.579000000000001
10149	82	10025	157.5
10149	83	10025	70
10149	89	10025	157.5
10149	89	10026	45
10149	90	10025	70
10149	90	10026	20
10150	91	10025	15.741250000000001
10150	91	10026	4.4974999999999996
10150	92	10025	9.9697499999999994
10150	92	10026	2.8485
10150	93	10025	10.493
10151	94	10025	9.9697499999999994
10151	94	10026	2.8485
10151	95	10025	7.8697499999999998
10152	96	10025	26.2395
10152	97	10025	7.8697499999999998
10152	98	10025	13.11975
10152	99	10025	26.2395
10152	100	10025	7.8697499999999998
10152	101	10025	13.11975
10144	105	10025	2.7999999999999998
10144	105	10026	0.80000000000000004
10144	106	10025	2.9732500000000002
10144	106	10026	0.84950000000000003
10145	107	10025	117.59999999999999
10145	108	10025	56.495249999999999
10145	109	10025	44.063249999999996
10145	110	10025	86.537499999999994
10179	113	10025	0.26250000000000001
10179	114	10025	0.69999999999999996
10180	115	10025	1.0482499999999999
10180	116	10025	3.3232499999999998
10180	117	10025	5.2465000000000002
10180	118	10025	1.7482500000000001
10189	120	10025	3.9375
10189	120	10026	1.125
10147	121	10025	19.939499999999999
10147	121	10026	5.6970000000000001
10147	122	10025	7.8697499999999998
10141	123	10025	89.197500000000005
10141	123	10026	25.484999999999999
10141	124	10025	77.700000000000003
10141	125	10025	41.868749999999999
10146	126	10025	2.0982500000000002
10146	127	10025	3.7625000000000002
10198	128	10025	0.26250000000000001
10198	129	10025	0.69999999999999996
\.


--
-- Data for Name: jcitems; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY jcitems (id, project_id, parts_id, description, qty, allocated, sellprice, fxsellprice, serialnumber, checkedin, checkedout, employee_id, notes) FROM stdin;
\.


--
-- Data for Name: language; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY language (code, description) FROM stdin;
\.


--
-- Data for Name: makemodel; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY makemodel (parts_id, make, model) FROM stdin;
\.


--
-- Data for Name: oe; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY oe (id, ordnumber, transdate, vendor_id, customer_id, amount, netamount, reqdate, taxincluded, shippingpoint, notes, curr, employee_id, closed, quotation, quonumber, intnotes, department_id, shipvia, language_code, ponumber, terms, waybill, warehouse_id, description, aa_id, exchangerate, ticket_id) FROM stdin;
10240	SO-028	2011-04-11	\N	10237	32.979999999999997	32.979999999999997	\N	\N	\N		GBP	\N	f	f	\N	\N	0	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
10242	SO-030	2011-04-11	\N	10237	17.989999999999998	17.989999999999998	\N	\N	\N		GBP	\N	f	f	\N	\N	0	\N	\N	\N	0	\N	\N	\N	\N	\N	\N
10241	SO-029	2011-04-11	0	10237	17.989999999999998	17.989999999999998	\N	f			GBP	10236	t	f			0				0		10134		10243	1	\N
\.


--
-- Data for Name: orderitems; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY orderitems (id, trans_id, parts_id, description, qty, sellprice, discount, unit, project_id, reqdate, ship, serialnumber, itemnotes, lineitemdetail, ordernumber, ponumber) FROM stdin;
106	10240	10117	The Claw Hand Rake	1	14.99	\N	NOS	\N	\N	\N	\N	\N	\N	\N	\N
107	10240	10115	Deluxe Hand Saw	1	17.989999999999998	\N	NOS	\N	\N	\N	\N	\N	\N	\N	\N
109	10242	10114	The Blade Hand Planer	0	19.989999999999998	\N	NOS	\N	\N	\N	\N	\N	\N	\N	\N
110	10242	10115	Deluxe Hand Saw	0	17.989999999999998	\N	NOS	\N	\N	\N	\N	\N	\N	\N	\N
111	10242	10115	Deluxe Hand Saw	1	17.989999999999998	\N	NOS	\N	\N	\N	\N	\N	\N	\N	\N
112	10241	10115	Deluxe Hand Saw	1	17.989999999999998	0	NOS	\N	\N	1			f		
\.


--
-- Data for Name: parts; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY parts (id, partnumber, description, unit, listprice, sellprice, lastcost, priceupdate, weight, onhand, notes, makemodel, assembly, alternate, rop, inventory_accno_id, income_accno_id, expense_accno_id, bin, obsolete, bom, image, drawing, microfiche, partsgroup_id, project_id, avgcost, tariff_hscode, countryorigin, barcode, toolnumber) FROM stdin;
10116	D009	Digger Hand Trencher	NOS	18.989999999999998	18.989999999999998	16.989999999999998	2007-04-29	0	18	The &quot;Digger&quot; is a gardeners dream. Specially designed for moving dirt it boasts two different styles of blade. Use the one side for trenching, or use the other side with it&#39;s wider angle to get hard to handle roots out of the ground. Available in 3&quot; size only.	f	f	f	0	10012	10038	10045		f	f	d009.gif			10107	\N	16.989999999999998				
10111	M004	Mini-Sledge	NOS	24.989999999999998	24.989999999999998	18.989999999999998	2007-04-29	0	11	Our mini-sledge hammer is superior for smaller jobs that require a little more power. Give this one a try on landscaping stakes and concrete frames.	f	f	f	0	10012	10038	10045		f	f	m004.gif			10104	\N	18.989999999999998				
10112	M005	Modeling Hammer	NOS	14.99	14.99	11.99	2007-04-29	0	19	Ideal for the hobbiest this modeling hammer is made for the delicate work. Fits easily into small spaces and the smaller head size is perfect for intricate projects.	f	f	f	0	10012	10038	10045		f	f	m005.gif			10104	\N	11.99				
10113	R006	Rubber Mallet	NOS	24.989999999999998	24.989999999999998	21.5	2007-04-29	0	21	Perfectly weighted and encased in rubber this mallet is designed for ease of use in all applications.	f	f	f	0	10012	10038	10045		f	f	r006.gif			10104	\N	21.5				
10110	F003	Framing Hammer	NOS	19.989999999999998	19.989999999999998	13.85	2007-04-29	0	0	Enjoy the perfect feel and swing of our line of hammers. This framing hammer is ideal for the most discriminating of carpenters. The handle is perfectly shaped to fit the hand and the head is weighted to get the most out of each swing.	f	f	f	0	10012	10038	10045		f	f	f003.gif			10104	\N	\N				
10109	H002	Hand Brush	NOS	5.9900000000000002	5.9900000000000002	4.3499999999999996	2007-04-29	0	42	The perfect precision hand planer. Our patented blade technology insures that you will never have to change or sharpen the blade. Available in 1&quot;, 1.5&quot;, and 2&quot; widths.	f	f	f	0	10012	10038	10045		f	f	h002.gif			10103	\N	4.3499999999999996				
10117	T010	The Claw Hand Rake	NOS	14.99	14.99	12	2007-04-29	0	17	Extend the reach of your potting with &quot;The Claw&quot;. Perfect for agitating soil in the most difficult places this 3 tine tool is ideal for every gardener. Small and Large sizes available.	f	f	f	0	10012	10038	10045		f	f	t010.gif			10107	\N	12				
10114	T007	The Blade Hand Planer	NOS	19.989999999999998	19.989999999999998	16.25	2007-04-29	0	0	The perfect precision hand planer. Our patented blade technology insures that you will never have to change or sharpen the blade. Available in 1&quot;, 1.5&quot;, and 2&quot; widths.	f	f	f	0	10012	10038	10045		f	f	t007.gif			10105	\N	\N				
10108	B001	Brush Set	NOS	9.9900000000000002	9.9900000000000002	7	2007-04-29	0	-1	This set includes 2&quot; and 3&quot; trim brushes and our ergonomically designer paint roller. A perfect choice for any painting project.	f	f	f	0	10012	10038	10045		f	f	b001.gif			10103	\N	\N				
10139	CLN	Cleaning	SQFT	0	1.5	1	2007-07-12	0	0		f	f	f	0	\N	10038	10045		f	f	cln.gif			10138	\N	\N				
10140	PAINT	Wall Paint	SQFT	0	2	1	2007-07-12	0	0		f	f	f	0	\N	10038	10045		f	f	paint.gif			10138	\N	\N				
10156	K001	Professional Kit		0	103.94	85.829999999999998	2008-01-01	0	0		f	t	f	0	\N	10038	\N		f	f	k001.gif			10155	\N	\N				
10115	D008	Deluxe Hand Saw	NOS	17.989999999999998	17.989999999999998	16	2007-04-29	0	37	Our deluxe hand saw is perfect for precision work. This saw features an ergonomic handle and **carbide tipped teeth**. \r\n\r\nSizes available:\r\n\r\n* 2&#39;\r\n* 2.5&#39;\r\n* 3&#39;	f	f	f	0	10012	10038	10045		f	f	d008.gif			10106	\N	16				
\.


--
-- Data for Name: partsattr; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY partsattr (parts_id, hotnew) FROM stdin;
10116	hot
10114	hot
10108	hot
10113	new
10117	new
10115	new
\.


--
-- Data for Name: partscustomer; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY partscustomer (parts_id, customer_id, pricegroup_id, pricebreak, sellprice, validfrom, validto, curr) FROM stdin;
\.


--
-- Data for Name: partsgroup; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY partsgroup (id, partsgroup, pos) FROM stdin;
10138	Services	f
10103	Brushes	t
10104	Hammers	t
10105	Hand Planes	t
10106	Hand Saws	t
10107	Picks & Hatchets	t
10155	Kits	f
\.


--
-- Data for Name: partstax; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY partstax (parts_id, chart_id) FROM stdin;
10109	10025
10113	10025
10111	10025
10112	10025
10114	10025
10117	10025
10140	10025
10140	10026
10156	10025
10156	10026
10108	10025
10108	10026
10139	10025
10139	10026
10115	10025
10115	10026
10110	10025
10110	10026
10116	10025
10116	10026
\.


--
-- Data for Name: partsvendor; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY partsvendor (vendor_id, parts_id, partnumber, leadtime, lastcost, curr) FROM stdin;
\.


--
-- Data for Name: payment; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY payment (id, trans_id, exchangerate, paymentmethod_id) FROM stdin;
1	10148	1	0
1	10149	1	0
1	10145	1	0
\.


--
-- Data for Name: paymentmethod; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY paymentmethod (id, description, fee, rn) FROM stdin;
\.


--
-- Data for Name: pricegroup; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY pricegroup (id, pricegroup) FROM stdin;
\.


--
-- Data for Name: project; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY project (id, projectnumber, description, startdate, enddate, parts_id, production, completed, customer_id) FROM stdin;
10159	P1		2006-12-03	\N	\N	0	0	\N
10160	P2		2006-12-03	\N	\N	0	0	\N
10161	P3		2006-12-03	\N	\N	0	0	\N
\.


--
-- Data for Name: recurring; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY recurring (id, reference, startdate, nextdate, enddate, repeat, unit, howmany, payment, description) FROM stdin;
\.


--
-- Data for Name: recurringemail; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY recurringemail (id, formname, format, message) FROM stdin;
\.


--
-- Data for Name: recurringprint; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY recurringprint (id, formname, format, printer) FROM stdin;
\.


--
-- Data for Name: report; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY report (reportid, reportcode, reportdescription, login) FROM stdin;
\.


--
-- Data for Name: reportvars; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY reportvars (reportid, reportvariable, reportvalue) FROM stdin;
\.


--
-- Data for Name: semaphore; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY semaphore (id, login, module, expires) FROM stdin;
\.


--
-- Data for Name: shipto; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY shipto (trans_id, shiptoname, shiptoaddress1, shiptoaddress2, shiptocity, shiptostate, shiptozipcode, shiptocountry, shiptocontact, shiptophone, shiptofax, shiptoemail) FROM stdin;
10188	ABC Channel 2	Ichhra	Lahore	Lahore	Punjab	54600	Pakistan	Armahgan Saqib	123	123	ar.saqib@gmail.com
10189	Any shipto 	address	here								
10191	Ledger123 again - shipping	shipping address	1	2	3	4	5	6	7	8	9
10192	Saqib Awan associates	102, Madni St	Ichrra	London	UK	AA2BB3	UK				
10193	Saqib Awan associates	102, Madni St	Ichrra	London	UK	AA2BB3	UK				
10194	Saqib Awan associates	102, Madni St	Ichrra	London	UK	AA2BB3	UK				
\.


--
-- Data for Name: sic; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY sic (code, sictype, description) FROM stdin;
\.


--
-- Data for Name: status; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY status (trans_id, formname, printed, emailed, spoolfile) FROM stdin;
\.


--
-- Data for Name: tax; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY tax (chart_id, rate, taxnumber, validto) FROM stdin;
10025	0.17499999999999999	\N	\N
10026	0.050000000000000003	\N	\N
\.


--
-- Data for Name: translation; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY translation (trans_id, language_code, description) FROM stdin;
\.


--
-- Data for Name: trf; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY trf (id, transdate, trfnumber, description, notes, department_id, from_warehouse_id, to_warehouse_id, employee_id, delivereddate, ticket_id) FROM stdin;
10157	2009-03-25	trf01			10136	10134	10135	10102	\N	\N
10158	2009-03-25	trf02			10136	10134	10135	10102	\N	\N
\.


--
-- Data for Name: vendor; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY vendor (id, name, contact, phone, fax, email, notes, terms, taxincluded, vendornumber, cc, bcc, gifi_accno, business_id, taxnumber, sic_code, discount, creditlimit, iban, bic, employee_id, language_code, pricegroup_id, curr, startdate, enddate, arap_accno_id, payment_accno_id, discount_accno_id, cashdiscount, discountterms, threshold, paymentmethod_id, remittancevoucher) FROM stdin;
10132	Skybird Agro Industries	Michael KIng					0	f	SA003				0			0	0			10102		0	GBP	2007-04-29	\N	\N	\N	\N	0	0	0	\N	\N
10130	Construct Buildings Plc	Thomas Lucas					0	f	CB001				0			0	0			10102		0	GBP	2007-04-29	\N	\N	\N	\N	0	0	0	0	f
10131	Engineering Supplies Plc	John King					0	f	ES002				0			0	0			10102		0	GBP	2007-04-29	\N	\N	\N	\N	0	0	0	0	f
\.


--
-- Data for Name: vendortax; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY vendortax (vendor_id, chart_id) FROM stdin;
10132	10025
10130	10025
10130	10026
10131	10025
10131	10026
\.


--
-- Data for Name: vr; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY vr (br_id, trans_id, id, vouchernumber) FROM stdin;
\.


--
-- Data for Name: warehouse; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY warehouse (id, description) FROM stdin;
10134	LONDON
10135	PARIS
\.


--
-- Data for Name: yearend; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY yearend (trans_id, transdate) FROM stdin;
\.


--
-- Name: address_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY address
    ADD CONSTRAINT address_pkey PRIMARY KEY (id);


--
-- Name: br_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY br
    ADD CONSTRAINT br_pkey PRIMARY KEY (id);


--
-- Name: build_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY build
    ADD CONSTRAINT build_pkey PRIMARY KEY (id);


--
-- Name: contact_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY contact
    ADD CONSTRAINT contact_pkey PRIMARY KEY (id);


--
-- Name: curr_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY curr
    ADD CONSTRAINT curr_pkey PRIMARY KEY (curr);


--
-- Name: customer_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY customer
    ADD CONSTRAINT customer_pkey PRIMARY KEY (id);


--
-- Name: customerlogin_login_key; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY customerlogin
    ADD CONSTRAINT customerlogin_login_key UNIQUE (login);


--
-- Name: customerlogin_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY customerlogin
    ADD CONSTRAINT customerlogin_pkey PRIMARY KEY (id);


--
-- Name: customerlogin_session_key; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY customerlogin
    ADD CONSTRAINT customerlogin_session_key UNIQUE (session);


--
-- Name: paymentmethod_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY paymentmethod
    ADD CONSTRAINT paymentmethod_pkey PRIMARY KEY (id);


--
-- Name: report_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY report
    ADD CONSTRAINT report_pkey PRIMARY KEY (reportid);


--
-- Name: trf_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY trf
    ADD CONSTRAINT trf_pkey PRIMARY KEY (id);


--
-- Name: vendor_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY vendor
    ADD CONSTRAINT vendor_pkey PRIMARY KEY (id);


--
-- Name: acc_trans_chart_id_key; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX acc_trans_chart_id_key ON acc_trans USING btree (chart_id);


--
-- Name: acc_trans_source_key; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX acc_trans_source_key ON acc_trans USING btree (lower(source));


--
-- Name: acc_trans_trans_id_key; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX acc_trans_trans_id_key ON acc_trans USING btree (trans_id);


--
-- Name: acc_trans_transdate_key; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX acc_trans_transdate_key ON acc_trans USING btree (transdate);


--
-- Name: ap_employee_id_key; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX ap_employee_id_key ON ap USING btree (employee_id);


--
-- Name: ap_id_key; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX ap_id_key ON ap USING btree (id);


--
-- Name: ap_invnumber_key; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX ap_invnumber_key ON ap USING btree (invnumber);


--
-- Name: ap_ordnumber_key; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX ap_ordnumber_key ON ap USING btree (ordnumber);


--
-- Name: ap_quonumber_key; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX ap_quonumber_key ON ap USING btree (quonumber);


--
-- Name: ap_transdate_key; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX ap_transdate_key ON ap USING btree (transdate);


--
-- Name: ap_vendor_id_key; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX ap_vendor_id_key ON ap USING btree (vendor_id);


--
-- Name: ar_customer_id_key; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX ar_customer_id_key ON ar USING btree (customer_id);


--
-- Name: ar_employee_id_key; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX ar_employee_id_key ON ar USING btree (employee_id);


--
-- Name: ar_id_key; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX ar_id_key ON ar USING btree (id);


--
-- Name: ar_invnumber_key; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX ar_invnumber_key ON ar USING btree (invnumber);


--
-- Name: ar_ordnumber_key; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX ar_ordnumber_key ON ar USING btree (ordnumber);


--
-- Name: ar_quonumber_key; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX ar_quonumber_key ON ar USING btree (quonumber);


--
-- Name: ar_transdate_key; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX ar_transdate_key ON ar USING btree (transdate);


--
-- Name: assembly_id_key; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX assembly_id_key ON assembly USING btree (id);


--
-- Name: audittrail_trans_id_key; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX audittrail_trans_id_key ON audittrail USING btree (trans_id);


--
-- Name: cargo_id_key; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX cargo_id_key ON cargo USING btree (id, trans_id);


--
-- Name: chart_accno_key; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE UNIQUE INDEX chart_accno_key ON chart USING btree (accno);


--
-- Name: chart_category_key; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX chart_category_key ON chart USING btree (category);


--
-- Name: chart_gifi_accno_key; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX chart_gifi_accno_key ON chart USING btree (gifi_accno);


--
-- Name: chart_id_key; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX chart_id_key ON chart USING btree (id);


--
-- Name: chart_link_key; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX chart_link_key ON chart USING btree (link);


--
-- Name: customer_contact_key; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX customer_contact_key ON customer USING btree (lower((contact)::text));


--
-- Name: customer_customer_id_key; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX customer_customer_id_key ON customertax USING btree (customer_id);


--
-- Name: customer_customernumber_key; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX customer_customernumber_key ON customer USING btree (customernumber);


--
-- Name: customer_name_key; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX customer_name_key ON customer USING btree (lower((name)::text));


--
-- Name: department_id_key; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX department_id_key ON department USING btree (id);


--
-- Name: employee_id_key; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX employee_id_key ON employee USING btree (id);


--
-- Name: employee_login_key; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE UNIQUE INDEX employee_login_key ON employee USING btree (login);


--
-- Name: employee_name_key; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX employee_name_key ON employee USING btree (lower((name)::text));


--
-- Name: exchangerate_ct_key; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX exchangerate_ct_key ON exchangerate USING btree (curr, transdate);


--
-- Name: fifo_parts_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX fifo_parts_id ON fifo USING btree (parts_id);


--
-- Name: fifo_trans_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX fifo_trans_id ON fifo USING btree (trans_id);


--
-- Name: gifi_accno_key; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE UNIQUE INDEX gifi_accno_key ON gifi USING btree (accno);


--
-- Name: gl_description_key; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX gl_description_key ON gl USING btree (lower(description));


--
-- Name: gl_employee_id_key; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX gl_employee_id_key ON gl USING btree (employee_id);


--
-- Name: gl_id_key; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX gl_id_key ON gl USING btree (id);


--
-- Name: gl_reference_key; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX gl_reference_key ON gl USING btree (reference);


--
-- Name: gl_transdate_key; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX gl_transdate_key ON gl USING btree (transdate);


--
-- Name: inventory_invoice_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX inventory_invoice_id ON inventory USING btree (invoice_id);


--
-- Name: inventory_parts_id_key; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX inventory_parts_id_key ON inventory USING btree (parts_id);


--
-- Name: invoice_id_key; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX invoice_id_key ON invoice USING btree (id);


--
-- Name: invoice_parts_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX invoice_parts_id ON invoice USING btree (parts_id);


--
-- Name: invoice_qty; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX invoice_qty ON invoice USING btree (qty);


--
-- Name: invoice_trans_id_key; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX invoice_trans_id_key ON invoice USING btree (trans_id);


--
-- Name: jcitems_id_key; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX jcitems_id_key ON jcitems USING btree (id);


--
-- Name: language_code_key; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE UNIQUE INDEX language_code_key ON language USING btree (code);


--
-- Name: makemodel_make_key; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX makemodel_make_key ON makemodel USING btree (lower(make));


--
-- Name: makemodel_model_key; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX makemodel_model_key ON makemodel USING btree (lower(model));


--
-- Name: makemodel_parts_id_key; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX makemodel_parts_id_key ON makemodel USING btree (parts_id);


--
-- Name: oe_employee_id_key; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX oe_employee_id_key ON oe USING btree (employee_id);


--
-- Name: oe_id_key; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX oe_id_key ON oe USING btree (id);


--
-- Name: oe_ordnumber_key; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX oe_ordnumber_key ON oe USING btree (ordnumber);


--
-- Name: oe_transdate_key; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX oe_transdate_key ON oe USING btree (transdate);


--
-- Name: orderitems_trans_id_key; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX orderitems_trans_id_key ON orderitems USING btree (trans_id);


--
-- Name: parts_description_key; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX parts_description_key ON parts USING btree (lower(description));


--
-- Name: parts_id_key; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX parts_id_key ON parts USING btree (id);


--
-- Name: parts_partnumber_key; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX parts_partnumber_key ON parts USING btree (lower(partnumber));


--
-- Name: partscustomer_customer_id_key; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX partscustomer_customer_id_key ON partscustomer USING btree (customer_id);


--
-- Name: partscustomer_parts_id_key; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX partscustomer_parts_id_key ON partscustomer USING btree (parts_id);


--
-- Name: partsgroup_id_key; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX partsgroup_id_key ON partsgroup USING btree (id);


--
-- Name: partsgroup_key; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE UNIQUE INDEX partsgroup_key ON partsgroup USING btree (partsgroup);


--
-- Name: partstax_parts_id_key; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX partstax_parts_id_key ON partstax USING btree (parts_id);


--
-- Name: partsvendor_parts_id_key; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX partsvendor_parts_id_key ON partsvendor USING btree (parts_id);


--
-- Name: partsvendor_vendor_id_key; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX partsvendor_vendor_id_key ON partsvendor USING btree (vendor_id);


--
-- Name: pricegroup_id_key; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX pricegroup_id_key ON pricegroup USING btree (id);


--
-- Name: pricegroup_pricegroup_key; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX pricegroup_pricegroup_key ON pricegroup USING btree (pricegroup);


--
-- Name: project_id_key; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX project_id_key ON project USING btree (id);


--
-- Name: projectnumber_key; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE UNIQUE INDEX projectnumber_key ON project USING btree (projectnumber);


--
-- Name: shipto_trans_id_key; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX shipto_trans_id_key ON shipto USING btree (trans_id);


--
-- Name: status_trans_id_key; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX status_trans_id_key ON status USING btree (trans_id);


--
-- Name: translation_trans_id_key; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX translation_trans_id_key ON translation USING btree (trans_id);


--
-- Name: vendor_contact_key; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX vendor_contact_key ON vendor USING btree (lower((contact)::text));


--
-- Name: vendor_name_key; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX vendor_name_key ON vendor USING btree (lower((name)::text));


--
-- Name: vendor_vendornumber_key; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX vendor_vendornumber_key ON vendor USING btree (vendornumber);


--
-- Name: vendortax_vendor_id_key; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX vendortax_vendor_id_key ON vendortax USING btree (vendor_id);


--
-- Name: vr_br_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY vr
    ADD CONSTRAINT vr_br_id_fkey FOREIGN KEY (br_id) REFERENCES br(id) ON DELETE CASCADE;


--
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--

