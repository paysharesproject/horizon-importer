--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

SET search_path = public, pg_catalog;

DROP INDEX public.signersaccount;
DROP INDEX public.priceindex;
DROP INDEX public.paysissuerindex;
DROP INDEX public.ledgersbyseq;
DROP INDEX public.getsissuerindex;
DROP INDEX public.accountlines;
DROP INDEX public.accountbalances;
ALTER TABLE ONLY public.txhistory DROP CONSTRAINT txhistory_pkey;
ALTER TABLE ONLY public.txhistory DROP CONSTRAINT txhistory_ledgerseq_txindex_key;
ALTER TABLE ONLY public.trustlines DROP CONSTRAINT trustlines_pkey;
ALTER TABLE ONLY public.storestate DROP CONSTRAINT storestate_pkey;
ALTER TABLE ONLY public.signers DROP CONSTRAINT signers_pkey;
ALTER TABLE ONLY public.peers DROP CONSTRAINT peers_pkey;
ALTER TABLE ONLY public.offers DROP CONSTRAINT offers_pkey;
ALTER TABLE ONLY public.ledgerheaders DROP CONSTRAINT ledgerheaders_pkey;
ALTER TABLE ONLY public.ledgerheaders DROP CONSTRAINT ledgerheaders_ledgerseq_key;
ALTER TABLE ONLY public.accounts DROP CONSTRAINT accounts_pkey;
DROP TABLE public.txhistory;
DROP TABLE public.trustlines;
DROP TABLE public.storestate;
DROP TABLE public.signers;
DROP TABLE public.peers;
DROP TABLE public.offers;
DROP TABLE public.ledgerheaders;
DROP TABLE public.accounts;
DROP EXTENSION plpgsql;
DROP SCHEMA public;
--
-- Name: public; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA public;


--
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON SCHEMA public IS 'standard public schema';


--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: accounts; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE accounts (
    accountid character varying(51) NOT NULL,
    balance bigint NOT NULL,
    seqnum bigint NOT NULL,
    numsubentries integer NOT NULL,
    inflationdest character varying(51),
    homedomain character varying(32),
    thresholds text,
    flags integer NOT NULL,
    CONSTRAINT accounts_balance_check CHECK ((balance >= 0)),
    CONSTRAINT accounts_numsubentries_check CHECK ((numsubentries >= 0))
);


--
-- Name: ledgerheaders; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE ledgerheaders (
    ledgerhash character(64) NOT NULL,
    prevhash character(64) NOT NULL,
    bucketlisthash character(64) NOT NULL,
    ledgerseq integer,
    closetime bigint NOT NULL,
    data text NOT NULL,
    CONSTRAINT ledgerheaders_closetime_check CHECK ((closetime >= 0)),
    CONSTRAINT ledgerheaders_ledgerseq_check CHECK ((ledgerseq >= 0))
);


--
-- Name: offers; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE offers (
    accountid character varying(51) NOT NULL,
    offerid bigint NOT NULL,
    paysalphanumcurrency character varying(4),
    paysissuer character varying(51),
    getsalphanumcurrency character varying(4),
    getsissuer character varying(51),
    amount bigint NOT NULL,
    pricen integer NOT NULL,
    priced integer NOT NULL,
    price bigint NOT NULL,
    CONSTRAINT offers_amount_check CHECK ((amount >= 0)),
    CONSTRAINT offers_offerid_check CHECK ((offerid >= 0))
);


--
-- Name: peers; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE peers (
    ip character varying(15) NOT NULL,
    port integer DEFAULT 0 NOT NULL,
    nextattempt timestamp without time zone NOT NULL,
    numfailures integer DEFAULT 0 NOT NULL,
    rank integer DEFAULT 0 NOT NULL,
    CONSTRAINT peers_numfailures_check CHECK ((numfailures >= 0)),
    CONSTRAINT peers_port_check CHECK (((port > 0) AND (port <= 65535))),
    CONSTRAINT peers_rank_check CHECK ((rank >= 0))
);


--
-- Name: signers; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE signers (
    accountid character varying(51) NOT NULL,
    publickey character varying(51) NOT NULL,
    weight integer NOT NULL
);


--
-- Name: storestate; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE storestate (
    statename character(32) NOT NULL,
    state text
);


--
-- Name: trustlines; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE trustlines (
    accountid character varying(51) NOT NULL,
    issuer character varying(51) NOT NULL,
    alphanumcurrency character varying(4) NOT NULL,
    tlimit bigint DEFAULT 0 NOT NULL,
    balance bigint DEFAULT 0 NOT NULL,
    flags integer NOT NULL,
    CONSTRAINT trustlines_balance_check CHECK ((balance >= 0)),
    CONSTRAINT trustlines_tlimit_check CHECK ((tlimit >= 0))
);


--
-- Name: txhistory; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE txhistory (
    txid character(64) NOT NULL,
    ledgerseq integer NOT NULL,
    txindex integer NOT NULL,
    txbody text NOT NULL,
    txresult text NOT NULL,
    txmeta text NOT NULL,
    CONSTRAINT txhistory_ledgerseq_check CHECK ((ledgerseq >= 0))
);


--
-- Data for Name: accounts; Type: TABLE DATA; Schema: public; Owner: -
--

COPY accounts (accountid, balance, seqnum, numsubentries, inflationdest, homedomain, thresholds, flags) FROM stdin;
gspbxqXqEUZkiCCEFFCN9Vu4FLucdjLLdLcsV6E82Qc1T7ehsTC	99999995999999960	4	0	\N		01000000	0
ghdX3N5TNkfsorMmu88BqXWATUhfQBuBLkdPoVJSyuPjTnfLPg	999999990	12884901889	0	\N		01000000	0
ghpKUSBq3XShu9bX4LWb4cWLJd1hzHi4Kf4AKSq9qG5G8f2wBR	999999990	12884901889	0	\N		01000000	0
gbzGxDzwcyNB6K8BtPcW6RF1ARXjjRT5FeD3bjaN88EYoQsRqU	999999950	12884901893	5	\N		01000000	0
ghG5pVgqRyho86gB8FMPg56mfuq1R2cgKauntzYkzTgYxvvjaQ	999999960	12884901892	3	\N		01000000	0
\.


--
-- Data for Name: ledgerheaders; Type: TABLE DATA; Schema: public; Owner: -
--

COPY ledgerheaders (ledgerhash, prevhash, bucketlisthash, ledgerseq, closetime, data) FROM stdin;
41310a0181a3a82ff13c049369504e978734cf17da1baf02f7e4d881e8608371	0000000000000000000000000000000000000000000000000000000000000000	e71064e28d0740ac27cf07b267200ea9b8916ad1242195c015fa3012086588d3	1	0	AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA5xBk4o0HQKwnzweyZyAOqbiRatEkIZXAFfowEghliNMAAAABAAAAAAAAAAABY0V4XYoAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACgCYloA=
f2bad86d76baa9d3394b797f2ae92a5b20d76a317944fdedc68843e92d853bb3	41310a0181a3a82ff13c049369504e978734cf17da1baf02f7e4d881e8608371	24128cf784e4c94f58a5a72a5036a54e82b2e37c1b1b327bd8af8ab48684abf6	2	1433452674	QTEKAYGjqC/xPASTaVBOl4c0zxfaG68C9+TYgehgg3HWnizXf2VvYXCoygkt/wDezda8dXZTRIUXo6e9UAqQU+OwxEKY/BwUmvv0yJlvuSQnrkHkZJuTTKSVmRt4UrhVJBKM94TkyU9YpacqUDalToKy43wbGzJ72K+KtIaEq/YAAAACAAAAAFVwwIIBY0V4XYoAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACgCYloA=
a412518e9066d1fe9fae4c0ee08088fd356f2a96b2a50ba6f2684a6674c0f5f1	f2bad86d76baa9d3394b797f2ae92a5b20d76a317944fdedc68843e92d853bb3	d33c3bfa8be4cd5bf48dff7706f2ad4ef4c61ce317ddea1a34946a1173b2bed5	3	1433452675	8rrYbXa6qdM5S3l/KukqWyDXajF5RP3txohD6S2FO7NgTUNKj9muhEJA+v0YZ+zN/Ya9B4I469lF8oCm/8HBMNhrpj8Zf+2Djn7jxjpxpJD2dFeeEYpDtkvJLlNv14co0zw7+ovkzVv0jf93BvKtTvTGHOMX3eoaNJRqEXOyvtUAAAADAAAAAFVwwIMBY0V4XYoAAAAAAAAAAAAoAAAAAAAAAAAAAAAAAAAACgCYloA=
49652708de8af028bdb46c4534a9cbc6a8b8cd0852688b25e725a7bbd410db64	a412518e9066d1fe9fae4c0ee08088fd356f2a96b2a50ba6f2684a6674c0f5f1	a95df494d62cc2adb80fae2c72a880e9bb7b7e39bc09d7b5c58f9d3cc93f7dc4	4	1433452676	pBJRjpBm0f6frkwO4ICI/TVvKpaypQum8mhKZnTA9fGTAeV90sTjvl0sCNDzUcNIaH06q2BGns003L4bcbuawKvXQDOsEOSee38m27VlHSwF72+ARV1ATzQmmGfdNuBaqV30lNYswq24D64scqiA6bt7fjm8Cde1xY+dPMk/fcQAAAAEAAAAAFVwwIQBY0V4XYoAAAAAAAAAAABQAAAAAAAAAAAAAAAAAAAACgCYloA=
3c988c9bd0e6bffe9983119da11018d476e6d7e549a0414accf0def8553970fe	49652708de8af028bdb46c4534a9cbc6a8b8cd0852688b25e725a7bbd410db64	9c208b73552658f60ce48c7849f5df7fb5c04eca643cf517e9ec7e50681fd00f	5	1433452677	SWUnCN6K8Ci9tGxFNKnLxqi4zQhSaIsl5yWnu9QQ22RMNGlrh573DwgH0hvIS7IR0UgYeAmx4bZPEIiURgfix07iivurP4F0eciD5e28DsDrJ6Sz3PDcQhScClf9v4aknCCLc1UmWPYM5Ix4SfXff7XATspkPPUX6ex+UGgf0A8AAAAFAAAAAFVwwIUBY0V4XYoAAAAAAAAAAABkAAAAAAAAAAAAAAAAAAAACgCYloA=
8d01ae4344af06ae04d1c3485d91942dbee0c9e7d32a87e24b5907a8dbdaed1e	3c988c9bd0e6bffe9983119da11018d476e6d7e549a0414accf0def8553970fe	59672909abe382f88ec5ae70bae898eeb7e441cfb13979fd9ee0641c02b74b93	6	1433452678	PJiMm9Dmv/6ZgxGdoRAY1Hbm1+VJoEFKzPDe+FU5cP7qj5QW00lthrR5dxoeowvLeaKPfpRfo42NhPFuJ+DRbV5u4qQa0YgNtL4gSEWVLtgXDQHmGjn1oTA5h+6WTveYWWcpCavjgviOxa5wuuiY7rfkQc+xOXn9nuBkHAK3S5MAAAAGAAAAAFVwwIYBY0V4XYoAAAAAAAAAAACCAAAAAAAAAAAAAAADAAAACgCYloA=
18e66798224d66b175e5ce41a272432f62e1a4d1e1c942e4fd0743e6a9b4e56f	8d01ae4344af06ae04d1c3485d91942dbee0c9e7d32a87e24b5907a8dbdaed1e	dcde7da8907058a67a92ad302179ccff822f41c3dc100fc6f7f3525508e0367e	7	1433452679	jQGuQ0SvBq4E0cNIXZGULb7gyefTKofiS1kHqNva7R7ZdZ+VDcyBJxO+Ef2YkePWVsjX3lH4t0QnyQ+z3OQhLBUn8lp198y4R3QqT9ckI+oINLbK+K1ZLWApAaxCqefB3N59qJBwWKZ6kq0wIXnM/4IvQcPcEA/G9/NSVQjgNn4AAAAHAAAAAFVwwIcBY0V4XYoAAAAAAAAAAACWAAAAAAAAAAAAAAAEAAAACgCYloA=
\.


--
-- Data for Name: offers; Type: TABLE DATA; Schema: public; Owner: -
--

COPY offers (accountid, offerid, paysalphanumcurrency, paysissuer, getsalphanumcurrency, getsissuer, amount, pricen, priced, price) FROM stdin;
gbzGxDzwcyNB6K8BtPcW6RF1ARXjjRT5FeD3bjaN88EYoQsRqU	2	USD	ghpKUSBq3XShu9bX4LWb4cWLJd1hzHi4Kf4AKSq9qG5G8f2wBR	EUR	ghdX3N5TNkfsorMmu88BqXWATUhfQBuBLkdPoVJSyuPjTnfLPg	1111111111	10	9	11111111
gbzGxDzwcyNB6K8BtPcW6RF1ARXjjRT5FeD3bjaN88EYoQsRqU	3	USD	ghpKUSBq3XShu9bX4LWb4cWLJd1hzHi4Kf4AKSq9qG5G8f2wBR	EUR	ghdX3N5TNkfsorMmu88BqXWATUhfQBuBLkdPoVJSyuPjTnfLPg	1250000000	5	4	12500000
gbzGxDzwcyNB6K8BtPcW6RF1ARXjjRT5FeD3bjaN88EYoQsRqU	1	USD	ghpKUSBq3XShu9bX4LWb4cWLJd1hzHi4Kf4AKSq9qG5G8f2wBR	EUR	ghdX3N5TNkfsorMmu88BqXWATUhfQBuBLkdPoVJSyuPjTnfLPg	500000000	1	1	10000000
ghG5pVgqRyho86gB8FMPg56mfuq1R2cgKauntzYkzTgYxvvjaQ	4	\N	\N	USD	ghpKUSBq3XShu9bX4LWb4cWLJd1hzHi4Kf4AKSq9qG5G8f2wBR	500000000	1	1	10000000
\.


--
-- Data for Name: peers; Type: TABLE DATA; Schema: public; Owner: -
--

COPY peers (ip, port, nextattempt, numfailures, rank) FROM stdin;
\.


--
-- Data for Name: signers; Type: TABLE DATA; Schema: public; Owner: -
--

COPY signers (accountid, publickey, weight) FROM stdin;
\.


--
-- Data for Name: storestate; Type: TABLE DATA; Schema: public; Owner: -
--

COPY storestate (statename, state) FROM stdin;
databaseinitialized             	true
forcescponnextlaunch            	false
lastclosedledger                	18e66798224d66b175e5ce41a272432f62e1a4d1e1c942e4fd0743e6a9b4e56f
historyarchivestate             	{\n    "version": 0,\n    "currentLedger": 7,\n    "currentBuckets": [\n        {\n            "curr": "5980c683e7dfeafe59cd3186b3ba8a4469566d0432281bf39fcaff60160a9a80",\n            "next": {\n                "state": 0\n            },\n            "snap": "23c4281f3fde5a47ca8565ae093e8bc2b7d98289fccf408a8c7bfc7635728937"\n        },\n        {\n            "curr": "33c18e69f4f75ec3736073468f831d321ddab2bb3a81492a02bb848dfd207056",\n            "next": {\n                "state": 1,\n                "output": "23c4281f3fde5a47ca8565ae093e8bc2b7d98289fccf408a8c7bfc7635728937"\n            },\n            "snap": "0000000000000000000000000000000000000000000000000000000000000000"\n        },\n        {\n            "curr": "0000000000000000000000000000000000000000000000000000000000000000",\n            "next": {\n                "state": 0\n            },\n            "snap": "0000000000000000000000000000000000000000000000000000000000000000"\n        },\n        {\n            "curr": "0000000000000000000000000000000000000000000000000000000000000000",\n            "next": {\n                "state": 0\n            },\n            "snap": "0000000000000000000000000000000000000000000000000000000000000000"\n        },\n        {\n            "curr": "0000000000000000000000000000000000000000000000000000000000000000",\n            "next": {\n                "state": 0\n            },\n            "snap": "0000000000000000000000000000000000000000000000000000000000000000"\n        },\n        {\n            "curr": "0000000000000000000000000000000000000000000000000000000000000000",\n            "next": {\n                "state": 0\n            },\n            "snap": "0000000000000000000000000000000000000000000000000000000000000000"\n        },\n        {\n            "curr": "0000000000000000000000000000000000000000000000000000000000000000",\n            "next": {\n                "state": 0\n            },\n            "snap": "0000000000000000000000000000000000000000000000000000000000000000"\n        },\n        {\n            "curr": "0000000000000000000000000000000000000000000000000000000000000000",\n            "next": {\n                "state": 0\n            },\n            "snap": "0000000000000000000000000000000000000000000000000000000000000000"\n        },\n        {\n            "curr": "0000000000000000000000000000000000000000000000000000000000000000",\n            "next": {\n                "state": 0\n            },\n            "snap": "0000000000000000000000000000000000000000000000000000000000000000"\n        },\n        {\n            "curr": "0000000000000000000000000000000000000000000000000000000000000000",\n            "next": {\n                "state": 0\n            },\n            "snap": "0000000000000000000000000000000000000000000000000000000000000000"\n        },\n        {\n            "curr": "0000000000000000000000000000000000000000000000000000000000000000",\n            "next": {\n                "state": 0\n            },\n            "snap": "0000000000000000000000000000000000000000000000000000000000000000"\n        }\n    ]\n}
\.


--
-- Data for Name: trustlines; Type: TABLE DATA; Schema: public; Owner: -
--

COPY trustlines (accountid, issuer, alphanumcurrency, tlimit, balance, flags) FROM stdin;
gbzGxDzwcyNB6K8BtPcW6RF1ARXjjRT5FeD3bjaN88EYoQsRqU	ghpKUSBq3XShu9bX4LWb4cWLJd1hzHi4Kf4AKSq9qG5G8f2wBR	USD	9223372036854775807	500000000	1
gbzGxDzwcyNB6K8BtPcW6RF1ARXjjRT5FeD3bjaN88EYoQsRqU	ghdX3N5TNkfsorMmu88BqXWATUhfQBuBLkdPoVJSyuPjTnfLPg	EUR	9223372036854775807	4500000000	1
ghG5pVgqRyho86gB8FMPg56mfuq1R2cgKauntzYkzTgYxvvjaQ	ghdX3N5TNkfsorMmu88BqXWATUhfQBuBLkdPoVJSyuPjTnfLPg	EUR	9223372036854775807	500000000	1
ghG5pVgqRyho86gB8FMPg56mfuq1R2cgKauntzYkzTgYxvvjaQ	ghpKUSBq3XShu9bX4LWb4cWLJd1hzHi4Kf4AKSq9qG5G8f2wBR	USD	9223372036854775807	4500000000	1
\.


--
-- Data for Name: txhistory; Type: TABLE DATA; Schema: public; Owner: -
--

COPY txhistory (txid, ledgerseq, txindex, txbody, txresult, txmeta) FROM stdin;
d7a53c5962376f23969e39fba12f391fea511e1c29cf4ebc6633fff4416a8fe0	3	1	iZsoQO1WNsVt3F8Usjl1958bojiNJpTkxW7N3clg5e8AAAAKAAAAAAAAAAEAAAAAAAAAAAAAAAEAAAAAAAAAAAdtQsF6kydMyC2KxEFgYjYD/VRj9N/SgyPURT/00WHbAAAAADuaygAAAAABiZsoQCRRUUSGFYpk5bYkSln4y7WMiOpFxnFW2BrcuuFn9+qKQk9uFg/PGEC6LbbRrREkJX+5x0LJ4Gv1NNh9YomLnAI=	16U8WWI3byOWnjn7oS85H+pRHhwpz068ZjP/9EFqj+AAAAAAAAAACgAAAAAAAAABAAAAAAAAAAAAAAAA	AAAAAgAAAAAAAAAAB21CwXqTJ0zILYrEQWBiNgP9VGP039KDI9RFP/TRYdsAAAAAO5rKAAAAAAMAAAAAAAAAAAAAAAAAAAAAAQAAAAAAAAAAAAAAAAAAAQAAAACJmyhA7VY2xW3cXxSyOXX3nxuiOI0mlOTFbs3dyWDl7wFjRXgh7zX2AAAAAAAAAAEAAAAAAAAAAAAAAAABAAAAAAAAAAAAAAA=
1c25bcf4aa6bc6fe325d19fce7710722cccf1ca9bde4b42125e44b495cf128dc	3	2	iZsoQO1WNsVt3F8Usjl1958bojiNJpTkxW7N3clg5e8AAAAKAAAAAAAAAAIAAAAAAAAAAAAAAAEAAAAAAAAAAE9xgq7tEgw7atrsiQHkYuzy+dtKo+70NQPsJgikGcjSAAAAADuaygAAAAABiZsoQM+wmHrqf2ine+P85fMFZJfxRsF2hOeOkUmXM6Jk9GKqxsVEDiZ/j5dUILWADSJlLt0WuB317ELamiLnZn4zigU=	HCW89Kprxv4yXRn853EHIszPHKm95LQhJeRLSVzxKNwAAAAAAAAACgAAAAAAAAABAAAAAAAAAAAAAAAA	AAAAAgAAAAAAAAAAT3GCru0SDDtq2uyJAeRi7PL520qj7vQ1A+wmCKQZyNIAAAAAO5rKAAAAAAMAAAAAAAAAAAAAAAAAAAAAAQAAAAAAAAAAAAAAAAAAAQAAAACJmyhA7VY2xW3cXxSyOXX3nxuiOI0mlOTFbs3dyWDl7wFjRXfmVGvsAAAAAAAAAAIAAAAAAAAAAAAAAAABAAAAAAAAAAAAAAA=
fff99c8c12fe7c305ac3cf80df69878154821dde49b0d6d78e511bbe05dbfd41	3	3	iZsoQO1WNsVt3F8Usjl1958bojiNJpTkxW7N3clg5e8AAAAKAAAAAAAAAAMAAAAAAAAAAAAAAAEAAAAAAAAAAAbnBsPGksyNAb4DUUdg1IcWLD58mes8RI8RMmLu8MTfAAAAADuaygAAAAABiZsoQMCAXg0EnUGIbW3asc2H7AXPUcrD9i0PGmWzQvJYWrvD7csvXftgo3tsqLPi/6IdRlvihcyQ9GG+/9M0ROhjzQA=	//mcjBL+fDBaw8+A32mHgVSCHd5JsNbXjlEbvgXb/UEAAAAAAAAACgAAAAAAAAABAAAAAAAAAAAAAAAA	AAAAAgAAAAAAAAAABucGw8aSzI0BvgNRR2DUhxYsPnyZ6zxEjxEyYu7wxN8AAAAAO5rKAAAAAAMAAAAAAAAAAAAAAAAAAAAAAQAAAAAAAAAAAAAAAAAAAQAAAACJmyhA7VY2xW3cXxSyOXX3nxuiOI0mlOTFbs3dyWDl7wFjRXequaHiAAAAAAAAAAMAAAAAAAAAAAAAAAABAAAAAAAAAAAAAAA=
c504015cb1200aafa438dfe10344242f7f2570a81f02afe66b9694c2f4c4f516	3	4	iZsoQO1WNsVt3F8Usjl1958bojiNJpTkxW7N3clg5e8AAAAKAAAAAAAAAAQAAAAAAAAAAAAAAAEAAAAAAAAAAAg91l9Ys7QdWW+5eOJeo0v24IHjupRqPCs//709qGLLAAAAADuaygAAAAABiZsoQMBJG+qBgnjMv6+t5k7eV5MHhKcKKviw0cxjDaHPRCqEJa5CrXY7Yb+nkCdksHUZp8a99O2Ml8YKpfL9ohkrogI=	xQQBXLEgCq+kON/hA0QkL38lcKgfAq/ma5aUwvTE9RYAAAAAAAAACgAAAAAAAAABAAAAAAAAAAAAAAAA	AAAAAgAAAAAAAAAACD3WX1iztB1Zb7l44l6jS/bggeO6lGo8Kz//vT2oYssAAAAAO5rKAAAAAAMAAAAAAAAAAAAAAAAAAAAAAQAAAAAAAAAAAAAAAAAAAQAAAACJmyhA7VY2xW3cXxSyOXX3nxuiOI0mlOTFbs3dyWDl7wFjRXdvHtfYAAAAAAAAAAQAAAAAAAAAAAAAAAABAAAAAAAAAAAAAAA=
f07830552abb8105e9986bf4abc3feee45b57eefa2344a39314b2e13e76e715c	4	1	B21CwXqTJ0zILYrEQWBiNgP9VGP039KDI9RFP/TRYdsAAAAKAAAAAwAAAAEAAAAAAAAAAAAAAAEAAAAAAAAABQAAAAFVU0QABucGw8aSzI0BvgNRR2DUhxYsPnyZ6zxEjxEyYu7wxN9//////////wAAAAEHbULB5Fh/bL9NlqloAGmxbr/ECSTxVPNFfjgyjYmyFcRf6UOFS3O1dUnrp41DbjNc7Y1WIFzcuRkcjQAqVnw+0/jkBA==	8HgwVSq7gQXpmGv0q8P+7kW1fu+iNEo5MUsuE+ducVwAAAAAAAAACgAAAAAAAAABAAAAAAAAAAUAAAAA	AAAAAgAAAAAAAAABB21CwXqTJ0zILYrEQWBiNgP9VGP039KDI9RFP/TRYdsAAAABVVNEAAbnBsPGksyNAb4DUUdg1IcWLD58mes8RI8RMmLu8MTfAAAAAAAAAAB//////////wAAAAEAAAABAAAAAAdtQsF6kydMyC2KxEFgYjYD/VRj9N/SgyPURT/00WHbAAAAADuayfYAAAADAAAAAQAAAAEAAAAAAAAAAAEAAAAAAAAAAAAAAA==
1b5676b60f59d7a4264794d43ce26474e937b4084a4751f4a99f9ff14eee952a	4	2	T3GCru0SDDtq2uyJAeRi7PL520qj7vQ1A+wmCKQZyNIAAAAKAAAAAwAAAAEAAAAAAAAAAAAAAAEAAAAAAAAABQAAAAFVU0QABucGw8aSzI0BvgNRR2DUhxYsPnyZ6zxEjxEyYu7wxN9//////////wAAAAFPcYKuN9Akf4T53+iu9G0GxqJC78AZ9ODJmkocDGdgCfUmVYACFqBS5OyGw5b+hBmw5+g8ukKpn9+B7GnCCHLcQD/LDA==	G1Z2tg9Z16QmR5TUPOJkdOk3tAhKR1H0qZ+f8U7ulSoAAAAAAAAACgAAAAAAAAABAAAAAAAAAAUAAAAA	AAAAAgAAAAAAAAABT3GCru0SDDtq2uyJAeRi7PL520qj7vQ1A+wmCKQZyNIAAAABVVNEAAbnBsPGksyNAb4DUUdg1IcWLD58mes8RI8RMmLu8MTfAAAAAAAAAAB//////////wAAAAEAAAABAAAAAE9xgq7tEgw7atrsiQHkYuzy+dtKo+70NQPsJgikGcjSAAAAADuayfYAAAADAAAAAQAAAAEAAAAAAAAAAAEAAAAAAAAAAAAAAA==
ab1c216a6a1d8d7ae9637e1ef7fe3da4d10f5249345b1d7c52e9cc79bfe127cb	4	3	T3GCru0SDDtq2uyJAeRi7PL520qj7vQ1A+wmCKQZyNIAAAAKAAAAAwAAAAIAAAAAAAAAAAAAAAEAAAAAAAAABQAAAAFFVVIACD3WX1iztB1Zb7l44l6jS/bggeO6lGo8Kz//vT2oYst//////////wAAAAFPcYKusAbAEkKiTzD2yoH/Xu2Y79gzxW4PJGuJj9VKEW1WmF8qMlLiGHjyGchqexo7uRNnhOd92o8ZS4GFIA5zFEBcAQ==	qxwhamodjXrpY34e9/49pNEPUkk0Wx18UunMeb/hJ8sAAAAAAAAACgAAAAAAAAABAAAAAAAAAAUAAAAA	AAAAAgAAAAAAAAABT3GCru0SDDtq2uyJAeRi7PL520qj7vQ1A+wmCKQZyNIAAAABRVVSAAg91l9Ys7QdWW+5eOJeo0v24IHjupRqPCs//709qGLLAAAAAAAAAAB//////////wAAAAEAAAABAAAAAE9xgq7tEgw7atrsiQHkYuzy+dtKo+70NQPsJgikGcjSAAAAADuayewAAAADAAAAAgAAAAIAAAAAAAAAAAEAAAAAAAAAAAAAAA==
e04a4722935b30d8045dd898b315d53564043aa93199d8bce65b1c7e45b32583	4	4	B21CwXqTJ0zILYrEQWBiNgP9VGP039KDI9RFP/TRYdsAAAAKAAAAAwAAAAIAAAAAAAAAAAAAAAEAAAAAAAAABQAAAAFFVVIACD3WX1iztB1Zb7l44l6jS/bggeO6lGo8Kz//vT2oYst//////////wAAAAEHbULBHiPyeURKzW3WxzaNr/l2B5DmD+BDKW9EMlZsIcS10dbC9diMJYpn+muyVdWcYoB3jbH9JHqLvIPfg8lGXEPcBQ==	4EpHIpNbMNgEXdiYsxXVNWQEOqkxmdi85lscfkWzJYMAAAAAAAAACgAAAAAAAAABAAAAAAAAAAUAAAAA	AAAAAgAAAAAAAAABB21CwXqTJ0zILYrEQWBiNgP9VGP039KDI9RFP/TRYdsAAAABRVVSAAg91l9Ys7QdWW+5eOJeo0v24IHjupRqPCs//709qGLLAAAAAAAAAAB//////////wAAAAEAAAABAAAAAAdtQsF6kydMyC2KxEFgYjYD/VRj9N/SgyPURT/00WHbAAAAADuayewAAAADAAAAAgAAAAIAAAAAAAAAAAEAAAAAAAAAAAAAAA==
292139b79c3aaf676895c677df44e3e69dadc06ce83e23a62bd3e5db08caeb12	5	1	CD3WX1iztB1Zb7l44l6jS/bggeO6lGo8Kz//vT2oYssAAAAKAAAAAwAAAAEAAAAAAAAAAAAAAAEAAAAAAAAAAU9xgq7tEgw7atrsiQHkYuzy+dtKo+70NQPsJgikGcjSAAAAAUVVUgAIPdZfWLO0HVlvuXjiXqNL9uCB47qUajwrP/+9PahiywAAAAEqBfIAAAAAAQg91l9LUcORoc7pt3LFEm83rHRh1JKU0og2OOJsqG4BP/j4R5TrQESl40JH5B2M1XZ+PoTbsmXQLuJkdPe5hH8Vw3kB	KSE5t5w6r2dolcZ330Tj5p2twGzoPiOmK9Pl2wjK6xIAAAAAAAAACgAAAAAAAAABAAAAAAAAAAEAAAAA	AAAAAgAAAAEAAAAACD3WX1iztB1Zb7l44l6jS/bggeO6lGo8Kz//vT2oYssAAAAAO5rJ9gAAAAMAAAABAAAAAAAAAAAAAAAAAQAAAAAAAAAAAAAAAAAAAQAAAAFPcYKu7RIMO2ra7IkB5GLs8vnbSqPu9DUD7CYIpBnI0gAAAAFFVVIACD3WX1iztB1Zb7l44l6jS/bggeO6lGo8Kz//vT2oYssAAAABKgXyAH//////////AAAAAQ==
8cc5980baba280e0feb3c178f6795b1e4c5c42d72bc73d8cbb405088c3bc01b9	5	2	BucGw8aSzI0BvgNRR2DUhxYsPnyZ6zxEjxEyYu7wxN8AAAAKAAAAAwAAAAEAAAAAAAAAAAAAAAEAAAAAAAAAAQdtQsF6kydMyC2KxEFgYjYD/VRj9N/SgyPURT/00WHbAAAAAVVTRAAG5wbDxpLMjQG+A1FHYNSHFiw+fJnrPESPETJi7vDE3wAAAAEqBfIAAAAAAQbnBsPFctkV+rGvf83FZkrxKaS6WbXwGa/eUlXwY0QyDjRw8r1H8QbQoPTn4bUO4BXAzc46Mx6bS/POo+7EDH8h4YkH	jMWYC6uigOD+s8F49nlbHkxcQtcrxz2Mu0BQiMO8AbkAAAAAAAAACgAAAAAAAAABAAAAAAAAAAEAAAAA	AAAAAgAAAAEAAAAABucGw8aSzI0BvgNRR2DUhxYsPnyZ6zxEjxEyYu7wxN8AAAAAO5rJ9gAAAAMAAAABAAAAAAAAAAAAAAAAAQAAAAAAAAAAAAAAAAAAAQAAAAEHbULBepMnTMgtisRBYGI2A/1UY/Tf0oMj1EU/9NFh2wAAAAFVU0QABucGw8aSzI0BvgNRR2DUhxYsPnyZ6zxEjxEyYu7wxN8AAAABKgXyAH//////////AAAAAQ==
69551ad850ca8522869261933d55b397ee7d38587fb3c2bb4823831d526cc1a9	6	1	T3GCru0SDDtq2uyJAeRi7PL520qj7vQ1A+wmCKQZyNIAAAAKAAAAAwAAAAMAAAAAAAAAAAAAAAEAAAAAAAAAAwAAAAFFVVIACD3WX1iztB1Zb7l44l6jS/bggeO6lGo8Kz//vT2oYssAAAABVVNEAAbnBsPGksyNAb4DUUdg1IcWLD58mes8RI8RMmLu8MTfAAAAADuaygAAAAABAAAAAQAAAAAAAAAAAAAAAU9xgq7r5B1r27/sNov6dehmDlRnAkR6V/azDNj1Bx/KPk0mCu9L2gzHlv2JWOL/M4kgcnWhFSChZYnoTnEXPeDtx8AN	aVUa2FDKhSKGkmGTPVWzl+59OFh/s8K7SCODHVJswakAAAAAAAAACgAAAAAAAAABAAAAAAAAAAMAAAAAAAAAAAAAAABPcYKu7RIMO2ra7IkB5GLs8vnbSqPu9DUD7CYIpBnI0gAAAAAAAAABAAAAAUVVUgAIPdZfWLO0HVlvuXjiXqNL9uCB47qUajwrP/+9PahiywAAAAFVU0QABucGw8aSzI0BvgNRR2DUhxYsPnyZ6zxEjxEyYu7wxN8AAAAAO5rKAAAAAAEAAAAB	AAAAAgAAAAAAAAACT3GCru0SDDtq2uyJAeRi7PL520qj7vQ1A+wmCKQZyNIAAAAAAAAAAQAAAAFFVVIACD3WX1iztB1Zb7l44l6jS/bggeO6lGo8Kz//vT2oYssAAAABVVNEAAbnBsPGksyNAb4DUUdg1IcWLD58mes8RI8RMmLu8MTfAAAAADuaygAAAAABAAAAAQAAAAEAAAAAT3GCru0SDDtq2uyJAeRi7PL520qj7vQ1A+wmCKQZyNIAAAAAO5rJ4gAAAAMAAAADAAAAAwAAAAAAAAAAAQAAAAAAAAAAAAAA
4743ad3107855da78b59a1cdf8e9b86477d6af6c5d81ba8ecafa2ab1b92d8122	6	2	T3GCru0SDDtq2uyJAeRi7PL520qj7vQ1A+wmCKQZyNIAAAAKAAAAAwAAAAQAAAAAAAAAAAAAAAEAAAAAAAAAAwAAAAFFVVIACD3WX1iztB1Zb7l44l6jS/bggeO6lGo8Kz//vT2oYssAAAABVVNEAAbnBsPGksyNAb4DUUdg1IcWLD58mes8RI8RMmLu8MTfAAAAAEI6NccAAAAKAAAACQAAAAAAAAAAAAAAAU9xgq6FvssYVXWs2DBpTETgz6xs5ZQIViUi+IewFV5gBX1S8xwHKVQb+YmA3koE6VFkByVGBot1E6Hc8XrvAXOsHQkC	R0OtMQeFXaeLWaHN+Om4ZHfWr2xdgbqOyvoqsbktgSIAAAAAAAAACgAAAAAAAAABAAAAAAAAAAMAAAAAAAAAAAAAAABPcYKu7RIMO2ra7IkB5GLs8vnbSqPu9DUD7CYIpBnI0gAAAAAAAAACAAAAAUVVUgAIPdZfWLO0HVlvuXjiXqNL9uCB47qUajwrP/+9PahiywAAAAFVU0QABucGw8aSzI0BvgNRR2DUhxYsPnyZ6zxEjxEyYu7wxN8AAAAAQjo1xwAAAAoAAAAJ	AAAAAgAAAAAAAAACT3GCru0SDDtq2uyJAeRi7PL520qj7vQ1A+wmCKQZyNIAAAAAAAAAAgAAAAFFVVIACD3WX1iztB1Zb7l44l6jS/bggeO6lGo8Kz//vT2oYssAAAABVVNEAAbnBsPGksyNAb4DUUdg1IcWLD58mes8RI8RMmLu8MTfAAAAAEI6NccAAAAKAAAACQAAAAEAAAAAT3GCru0SDDtq2uyJAeRi7PL520qj7vQ1A+wmCKQZyNIAAAAAO5rJ2AAAAAMAAAAEAAAABAAAAAAAAAAAAQAAAAAAAAAAAAAA
cb29e9218a75c79ece3322675d3b5f10a61b43f5e1bbd4539052c33961311a80	6	3	T3GCru0SDDtq2uyJAeRi7PL520qj7vQ1A+wmCKQZyNIAAAAKAAAAAwAAAAUAAAAAAAAAAAAAAAEAAAAAAAAAAwAAAAFFVVIACD3WX1iztB1Zb7l44l6jS/bggeO6lGo8Kz//vT2oYssAAAABVVNEAAbnBsPGksyNAb4DUUdg1IcWLD58mes8RI8RMmLu8MTfAAAAAEqBfIAAAAAFAAAABAAAAAAAAAAAAAAAAU9xgq5QKrp9Ka5kAAF8XMY2Wfn1d1ZNBIoHyn+aOjT26E4kJCDS5gfjLllK9Gnt6cK8AOxCa62U4KU9ZwaaPLnzW70H	yynpIYp1x57OMyJnXTtfEKYbQ/Xhu9RTkFLDOWExGoAAAAAAAAAACgAAAAAAAAABAAAAAAAAAAMAAAAAAAAAAAAAAABPcYKu7RIMO2ra7IkB5GLs8vnbSqPu9DUD7CYIpBnI0gAAAAAAAAADAAAAAUVVUgAIPdZfWLO0HVlvuXjiXqNL9uCB47qUajwrP/+9PahiywAAAAFVU0QABucGw8aSzI0BvgNRR2DUhxYsPnyZ6zxEjxEyYu7wxN8AAAAASoF8gAAAAAUAAAAE	AAAAAgAAAAAAAAACT3GCru0SDDtq2uyJAeRi7PL520qj7vQ1A+wmCKQZyNIAAAAAAAAAAwAAAAFFVVIACD3WX1iztB1Zb7l44l6jS/bggeO6lGo8Kz//vT2oYssAAAABVVNEAAbnBsPGksyNAb4DUUdg1IcWLD58mes8RI8RMmLu8MTfAAAAAEqBfIAAAAAFAAAABAAAAAEAAAAAT3GCru0SDDtq2uyJAeRi7PL520qj7vQ1A+wmCKQZyNIAAAAAO5rJzgAAAAMAAAAFAAAABQAAAAAAAAAAAQAAAAAAAAAAAAAA
e3cd450c7c0a030b5e3f6f86b1f7e5271b598283ad525821984540acc03cf88c	7	1	B21CwXqTJ0zILYrEQWBiNgP9VGP039KDI9RFP/TRYdsAAAAKAAAAAwAAAAMAAAAAAAAAAAAAAAEAAAAAAAAAAwAAAAFVU0QABucGw8aSzI0BvgNRR2DUhxYsPnyZ6zxEjxEyYu7wxN8AAAABRVVSAAg91l9Ys7QdWW+5eOJeo0v24IHjupRqPCs//709qGLLAAAAAB3NZQAAAAABAAAAAQAAAAAAAAAAAAAAAQdtQsEHDmFyscXM+XxmeDdJBU62gDgXnI2fWlE1UNqjDC2ZawbI8TVqBsCj7vBjlNE9PgJjDF9s5RpD9JWP37P44f4A	481FDHwKAwteP2+GsfflJxtZgoOtUlghmEVArMA8+IwAAAAAAAAACgAAAAAAAAABAAAAAAAAAAMAAAAAAAAAAU9xgq7tEgw7atrsiQHkYuzy+dtKo+70NQPsJgikGcjSAAAAAAAAAAEAAAABRVVSAAg91l9Ys7QdWW+5eOJeo0v24IHjupRqPCs//709qGLLAAAAAB3NZQAAAAAC	AAAABgAAAAEAAAAAB21CwXqTJ0zILYrEQWBiNgP9VGP039KDI9RFP/TRYdsAAAAAO5rJ4gAAAAMAAAADAAAAAgAAAAAAAAAAAQAAAAAAAAAAAAAAAAAAAQAAAAEHbULBepMnTMgtisRBYGI2A/1UY/Tf0oMj1EU/9NFh2wAAAAFFVVIACD3WX1iztB1Zb7l44l6jS/bggeO6lGo8Kz//vT2oYssAAAAAHc1lAH//////////AAAAAQAAAAEAAAABB21CwXqTJ0zILYrEQWBiNgP9VGP039KDI9RFP/TRYdsAAAABVVNEAAbnBsPGksyNAb4DUUdg1IcWLD58mes8RI8RMmLu8MTfAAAAAQw4jQB//////////wAAAAEAAAABAAAAAU9xgq7tEgw7atrsiQHkYuzy+dtKo+70NQPsJgikGcjSAAAAAUVVUgAIPdZfWLO0HVlvuXjiXqNL9uCB47qUajwrP/+9PahiywAAAAEMOI0Af/////////8AAAABAAAAAQAAAAFPcYKu7RIMO2ra7IkB5GLs8vnbSqPu9DUD7CYIpBnI0gAAAAFVU0QABucGw8aSzI0BvgNRR2DUhxYsPnyZ6zxEjxEyYu7wxN8AAAAAHc1lAH//////////AAAAAQAAAAEAAAACT3GCru0SDDtq2uyJAeRi7PL520qj7vQ1A+wmCKQZyNIAAAAAAAAAAQAAAAFFVVIACD3WX1iztB1Zb7l44l6jS/bggeO6lGo8Kz//vT2oYssAAAABVVNEAAbnBsPGksyNAb4DUUdg1IcWLD58mes8RI8RMmLu8MTfAAAAAB3NZQAAAAABAAAAAQ==
b88ae11c1adbf8e5fa657bfb3a50a5c1d25c069d503ea815fe26a338f0140a9b	7	2	B21CwXqTJ0zILYrEQWBiNgP9VGP039KDI9RFP/TRYdsAAAAKAAAAAwAAAAQAAAAAAAAAAAAAAAEAAAAAAAAAAwAAAAFVU0QABucGw8aSzI0BvgNRR2DUhxYsPnyZ6zxEjxEyYu7wxN8AAAAAAAAAAB3NZQAAAAABAAAAAQAAAAAAAAAAAAAAAQdtQsGG0aUxFG4L3XZvpTCp7cS67MFNtWUEON6OEIHTWr3Xmc6UR/C7u1HtTekNxtnwY3GngoWuWTin2Po64ljoZ0AM	uIrhHBrb+OX6ZXv7OlClwdJcBp1QPqgV/iajOPAUCpsAAAAAAAAACgAAAAAAAAABAAAAAAAAAAMAAAAAAAAAAAAAAAAHbULBepMnTMgtisRBYGI2A/1UY/Tf0oMj1EU/9NFh2wAAAAAAAAAEAAAAAVVTRAAG5wbDxpLMjQG+A1FHYNSHFiw+fJnrPESPETJi7vDE3wAAAAAAAAAAHc1lAAAAAAEAAAAB	AAAAAgAAAAAAAAACB21CwXqTJ0zILYrEQWBiNgP9VGP039KDI9RFP/TRYdsAAAAAAAAABAAAAAFVU0QABucGw8aSzI0BvgNRR2DUhxYsPnyZ6zxEjxEyYu7wxN8AAAAAAAAAAB3NZQAAAAABAAAAAQAAAAEAAAAAB21CwXqTJ0zILYrEQWBiNgP9VGP039KDI9RFP/TRYdsAAAAAO5rJ2AAAAAMAAAAEAAAAAwAAAAAAAAAAAQAAAAAAAAAAAAAA
\.


--
-- Name: accounts_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY accounts
    ADD CONSTRAINT accounts_pkey PRIMARY KEY (accountid);


--
-- Name: ledgerheaders_ledgerseq_key; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY ledgerheaders
    ADD CONSTRAINT ledgerheaders_ledgerseq_key UNIQUE (ledgerseq);


--
-- Name: ledgerheaders_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY ledgerheaders
    ADD CONSTRAINT ledgerheaders_pkey PRIMARY KEY (ledgerhash);


--
-- Name: offers_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY offers
    ADD CONSTRAINT offers_pkey PRIMARY KEY (offerid);


--
-- Name: peers_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY peers
    ADD CONSTRAINT peers_pkey PRIMARY KEY (ip, port);


--
-- Name: signers_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY signers
    ADD CONSTRAINT signers_pkey PRIMARY KEY (accountid, publickey);


--
-- Name: storestate_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY storestate
    ADD CONSTRAINT storestate_pkey PRIMARY KEY (statename);


--
-- Name: trustlines_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY trustlines
    ADD CONSTRAINT trustlines_pkey PRIMARY KEY (accountid, issuer, alphanumcurrency);


--
-- Name: txhistory_ledgerseq_txindex_key; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY txhistory
    ADD CONSTRAINT txhistory_ledgerseq_txindex_key UNIQUE (ledgerseq, txindex);


--
-- Name: txhistory_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY txhistory
    ADD CONSTRAINT txhistory_pkey PRIMARY KEY (txid, ledgerseq);


--
-- Name: accountbalances; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX accountbalances ON accounts USING btree (balance);


--
-- Name: accountlines; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX accountlines ON trustlines USING btree (accountid);


--
-- Name: getsissuerindex; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX getsissuerindex ON offers USING btree (getsissuer);


--
-- Name: ledgersbyseq; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX ledgersbyseq ON ledgerheaders USING btree (ledgerseq);


--
-- Name: paysissuerindex; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX paysissuerindex ON offers USING btree (paysissuer);


--
-- Name: priceindex; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX priceindex ON offers USING btree (price);


--
-- Name: signersaccount; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX signersaccount ON signers USING btree (accountid);


--
-- Name: public; Type: ACL; Schema: -; Owner: -
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM nullstyle;
GRANT ALL ON SCHEMA public TO nullstyle;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--

