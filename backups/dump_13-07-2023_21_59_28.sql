--
-- PostgreSQL database cluster dump
--

SET default_transaction_read_only = off;

SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;

--
-- Drop databases (except postgres and template1)
--

DROP DATABASE postgres_db;




--
-- Drop roles
--

DROP ROLE backend;


--
-- Roles
--

CREATE ROLE backend;
ALTER ROLE backend WITH SUPERUSER INHERIT CREATEROLE CREATEDB LOGIN REPLICATION BYPASSRLS PASSWORD 'SCRAM-SHA-256$4096:BcZXO1XF8JnlKFiN0xjrKg==$1Jq4Akjb0t0eODKc0Yb8GmEIJxKtFw16BpM2X/LqIUs=:uvZREmm4m4em/gNvbj+nlQODyvEqW/tPMVuAQ1M1STY=';

--
-- User Configurations
--








--
-- Databases
--

--
-- Database "template1" dump
--

--
-- PostgreSQL database dump
--

-- Dumped from database version 15.3 (Debian 15.3-1.pgdg120+1)
-- Dumped by pg_dump version 15.3 (Debian 15.3-1.pgdg120+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

UPDATE pg_catalog.pg_database SET datistemplate = false WHERE datname = 'template1';
DROP DATABASE template1;
--
-- Name: template1; Type: DATABASE; Schema: -; Owner: backend
--

CREATE DATABASE template1 WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'en_US.utf8';


ALTER DATABASE template1 OWNER TO backend;

\connect template1

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: DATABASE template1; Type: COMMENT; Schema: -; Owner: backend
--

COMMENT ON DATABASE template1 IS 'default template for new databases';


--
-- Name: template1; Type: DATABASE PROPERTIES; Schema: -; Owner: backend
--

ALTER DATABASE template1 IS_TEMPLATE = true;


\connect template1

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: DATABASE template1; Type: ACL; Schema: -; Owner: backend
--

REVOKE CONNECT,TEMPORARY ON DATABASE template1 FROM PUBLIC;
GRANT CONNECT ON DATABASE template1 TO PUBLIC;


--
-- PostgreSQL database dump complete
--

--
-- Database "postgres" dump
--

--
-- PostgreSQL database dump
--

-- Dumped from database version 15.3 (Debian 15.3-1.pgdg120+1)
-- Dumped by pg_dump version 15.3 (Debian 15.3-1.pgdg120+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

DROP DATABASE postgres;
--
-- Name: postgres; Type: DATABASE; Schema: -; Owner: backend
--

CREATE DATABASE postgres WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'en_US.utf8';


ALTER DATABASE postgres OWNER TO backend;

\connect postgres

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: DATABASE postgres; Type: COMMENT; Schema: -; Owner: backend
--

COMMENT ON DATABASE postgres IS 'default administrative connection database';


--
-- PostgreSQL database dump complete
--

--
-- Database "postgres_db" dump
--

--
-- PostgreSQL database dump
--

-- Dumped from database version 15.3 (Debian 15.3-1.pgdg120+1)
-- Dumped by pg_dump version 15.3 (Debian 15.3-1.pgdg120+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: postgres_db; Type: DATABASE; Schema: -; Owner: backend
--

CREATE DATABASE postgres_db WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'en_US.utf8';


ALTER DATABASE postgres_db OWNER TO backend;

\connect postgres_db

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: uniexams; Type: SCHEMA; Schema: -; Owner: backend
--

CREATE SCHEMA uniexams;


ALTER SCHEMA uniexams OWNER TO backend;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: exam; Type: TABLE; Schema: uniexams; Owner: backend
--

CREATE TABLE uniexams.exam (
    idexam integer NOT NULL,
    passingdate date,
    studentbadgenumber character varying(6),
    teacherbadgenumber character varying(6)
);


ALTER TABLE uniexams.exam OWNER TO backend;

--
-- Name: exam_idexam_seq; Type: SEQUENCE; Schema: uniexams; Owner: backend
--

CREATE SEQUENCE uniexams.exam_idexam_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE uniexams.exam_idexam_seq OWNER TO backend;

--
-- Name: exam_idexam_seq; Type: SEQUENCE OWNED BY; Schema: uniexams; Owner: backend
--

ALTER SEQUENCE uniexams.exam_idexam_seq OWNED BY uniexams.exam.idexam;


--
-- Name: redact; Type: TABLE; Schema: uniexams; Owner: backend
--

CREATE TABLE uniexams.redact (
    teacherbadgenumber character varying(6) NOT NULL,
    examid integer NOT NULL
);


ALTER TABLE uniexams.redact OWNER TO backend;

--
-- Name: student; Type: TABLE; Schema: uniexams; Owner: backend
--

CREATE TABLE uniexams.student (
    badgenumber character varying(6) NOT NULL,
    faculty character varying(128),
    courseyear integer,
    CONSTRAINT student_badgenumber_check CHECK ((length((badgenumber)::text) = 6)),
    CONSTRAINT student_courseyear_check CHECK ((courseyear < 4))
);


ALTER TABLE uniexams.student OWNER TO backend;

--
-- Name: teacher; Type: TABLE; Schema: uniexams; Owner: backend
--

CREATE TABLE uniexams.teacher (
    badgenumber character varying(6) NOT NULL,
    faculty character varying(128),
    CONSTRAINT teacher_badgenumber_check CHECK ((length((badgenumber)::text) = 6))
);


ALTER TABLE uniexams.teacher OWNER TO backend;

--
-- Name: test; Type: TABLE; Schema: uniexams; Owner: backend
--

CREATE TABLE uniexams.test (
    idtest integer NOT NULL,
    name character varying(128),
    testdate date,
    expirationdate date,
    valid boolean,
    vote integer,
    idoneus boolean,
    bonuspoints integer,
    examid integer,
    CONSTRAINT test_bonuspoints_check CHECK ((bonuspoints > 0)),
    CONSTRAINT test_vote_check CHECK (((vote >= 18) AND (vote <= 31)))
);


ALTER TABLE uniexams.test OWNER TO backend;

--
-- Name: test_idtest_seq; Type: SEQUENCE; Schema: uniexams; Owner: backend
--

CREATE SEQUENCE uniexams.test_idtest_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE uniexams.test_idtest_seq OWNER TO backend;

--
-- Name: test_idtest_seq; Type: SEQUENCE OWNED BY; Schema: uniexams; Owner: backend
--

ALTER SEQUENCE uniexams.test_idtest_seq OWNED BY uniexams.test.idtest;


--
-- Name: users; Type: TABLE; Schema: uniexams; Owner: backend
--

CREATE TABLE uniexams.users (
    badgenumber character varying(6) NOT NULL,
    name character varying(128),
    surname character varying(128),
    birthyear date,
    email character varying(128),
    password character varying(128),
    role character varying(128) NOT NULL,
    CONSTRAINT users_badgenumber_check CHECK ((length((badgenumber)::text) = 6)),
    CONSTRAINT users_role_check CHECK ((((role)::text = 'Student'::text) OR ((role)::text = 'Teacher'::text)))
);


ALTER TABLE uniexams.users OWNER TO backend;

--
-- Name: exam idexam; Type: DEFAULT; Schema: uniexams; Owner: backend
--

ALTER TABLE ONLY uniexams.exam ALTER COLUMN idexam SET DEFAULT nextval('uniexams.exam_idexam_seq'::regclass);


--
-- Name: test idtest; Type: DEFAULT; Schema: uniexams; Owner: backend
--

ALTER TABLE ONLY uniexams.test ALTER COLUMN idtest SET DEFAULT nextval('uniexams.test_idtest_seq'::regclass);


--
-- Data for Name: exam; Type: TABLE DATA; Schema: uniexams; Owner: backend
--

COPY uniexams.exam (idexam, passingdate, studentbadgenumber, teacherbadgenumber) FROM stdin;
10	2023-01-15	B12345	B23456
11	2023-02-20	B34567	B45678
12	2023-03-10	B56789	B67890
\.


--
-- Data for Name: redact; Type: TABLE DATA; Schema: uniexams; Owner: backend
--

COPY uniexams.redact (teacherbadgenumber, examid) FROM stdin;
B23456	10
B45678	11
B67890	12
\.


--
-- Data for Name: student; Type: TABLE DATA; Schema: uniexams; Owner: backend
--

COPY uniexams.student (badgenumber, faculty, courseyear) FROM stdin;
B12345	Computer Science	2
B34567	Mathematics	1
B56789	Physics	3
\.


--
-- Data for Name: teacher; Type: TABLE DATA; Schema: uniexams; Owner: backend
--

COPY uniexams.teacher (badgenumber, faculty) FROM stdin;
B23456	Computer Science
B45678	Mathematics
B67890	Physics
\.


--
-- Data for Name: test; Type: TABLE DATA; Schema: uniexams; Owner: backend
--

COPY uniexams.test (idtest, name, testdate, expirationdate, valid, vote, idoneus, bonuspoints, examid) FROM stdin;
6	Test 1	2023-01-20	2023-01-25	t	20	t	1	10
7	Test 2	2023-02-25	2023-03-01	t	25	f	2	11
8	Test 3	2023-03-15	2023-03-20	t	28	t	3	12
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: uniexams; Owner: backend
--

COPY uniexams.users (badgenumber, name, surname, birthyear, email, password, role) FROM stdin;
B12345	John	Doe	1990-01-01	john.doe@example.com	password123	Student
B23456	Jane	Smith	1992-05-15	jane.smith@example.com	password456	Teacher
B34567	Michael	Johnson	1985-09-10	michael.johnson@example.com	password789	Student
B45678	Emily	Davis	1993-07-20	emily.davis@example.com	password321	Teacher
B56789	David	Wilson	1991-03-07	david.wilson@example.com	password654	Student
B67890	Sarah	Brown	1988-12-12	sarah.brown@example.com	password987	Teacher
\.


--
-- Name: exam_idexam_seq; Type: SEQUENCE SET; Schema: uniexams; Owner: backend
--

SELECT pg_catalog.setval('uniexams.exam_idexam_seq', 12, true);


--
-- Name: test_idtest_seq; Type: SEQUENCE SET; Schema: uniexams; Owner: backend
--

SELECT pg_catalog.setval('uniexams.test_idtest_seq', 8, true);


--
-- Name: exam exam_pkey; Type: CONSTRAINT; Schema: uniexams; Owner: backend
--

ALTER TABLE ONLY uniexams.exam
    ADD CONSTRAINT exam_pkey PRIMARY KEY (idexam);


--
-- Name: redact redact_pkey; Type: CONSTRAINT; Schema: uniexams; Owner: backend
--

ALTER TABLE ONLY uniexams.redact
    ADD CONSTRAINT redact_pkey PRIMARY KEY (teacherbadgenumber, examid);


--
-- Name: student student_pkey; Type: CONSTRAINT; Schema: uniexams; Owner: backend
--

ALTER TABLE ONLY uniexams.student
    ADD CONSTRAINT student_pkey PRIMARY KEY (badgenumber);


--
-- Name: teacher teacher_pkey; Type: CONSTRAINT; Schema: uniexams; Owner: backend
--

ALTER TABLE ONLY uniexams.teacher
    ADD CONSTRAINT teacher_pkey PRIMARY KEY (badgenumber);


--
-- Name: users users_email_key; Type: CONSTRAINT; Schema: uniexams; Owner: backend
--

ALTER TABLE ONLY uniexams.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: uniexams; Owner: backend
--

ALTER TABLE ONLY uniexams.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (badgenumber);


--
-- Name: exam exam_studentbadgenumber_fkey; Type: FK CONSTRAINT; Schema: uniexams; Owner: backend
--

ALTER TABLE ONLY uniexams.exam
    ADD CONSTRAINT exam_studentbadgenumber_fkey FOREIGN KEY (studentbadgenumber) REFERENCES uniexams.student(badgenumber);


--
-- Name: exam exam_teacherbadgenumber_fkey; Type: FK CONSTRAINT; Schema: uniexams; Owner: backend
--

ALTER TABLE ONLY uniexams.exam
    ADD CONSTRAINT exam_teacherbadgenumber_fkey FOREIGN KEY (teacherbadgenumber) REFERENCES uniexams.teacher(badgenumber);


--
-- Name: redact redact_examid_fkey; Type: FK CONSTRAINT; Schema: uniexams; Owner: backend
--

ALTER TABLE ONLY uniexams.redact
    ADD CONSTRAINT redact_examid_fkey FOREIGN KEY (examid) REFERENCES uniexams.exam(idexam);


--
-- Name: redact redact_teacherbadgenumber_fkey; Type: FK CONSTRAINT; Schema: uniexams; Owner: backend
--

ALTER TABLE ONLY uniexams.redact
    ADD CONSTRAINT redact_teacherbadgenumber_fkey FOREIGN KEY (teacherbadgenumber) REFERENCES uniexams.teacher(badgenumber);


--
-- Name: student student_badgenumber_fkey; Type: FK CONSTRAINT; Schema: uniexams; Owner: backend
--

ALTER TABLE ONLY uniexams.student
    ADD CONSTRAINT student_badgenumber_fkey FOREIGN KEY (badgenumber) REFERENCES uniexams.users(badgenumber);


--
-- Name: teacher teacher_badgenumber_fkey; Type: FK CONSTRAINT; Schema: uniexams; Owner: backend
--

ALTER TABLE ONLY uniexams.teacher
    ADD CONSTRAINT teacher_badgenumber_fkey FOREIGN KEY (badgenumber) REFERENCES uniexams.users(badgenumber);


--
-- Name: test test_examid_fkey; Type: FK CONSTRAINT; Schema: uniexams; Owner: backend
--

ALTER TABLE ONLY uniexams.test
    ADD CONSTRAINT test_examid_fkey FOREIGN KEY (examid) REFERENCES uniexams.exam(idexam);


--
-- PostgreSQL database dump complete
--

--
-- PostgreSQL database cluster dump complete
--

