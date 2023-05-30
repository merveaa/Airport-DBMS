--
-- PostgreSQL database dump
--

-- Dumped from database version 14.5
-- Dumped by pg_dump version 15rc2

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
-- Name: public; Type: SCHEMA; Schema: -; Owner: postgres
--

-- *not* creating schema, since initdb creates it


ALTER SCHEMA public OWNER TO postgres;

--
-- Name: baggagetype(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.baggagetype("Weight" integer) RETURNS character varying
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF "Weight">10 THEN
        RETURN 'Cargo';
    ELSE
        RETURN 'Cabin';
    END IF;
END;
$$;


ALTER FUNCTION public.baggagetype("Weight" integer) OWNER TO postgres;

--
-- Name: bookedseatdecrease(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.bookedseatdecrease() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
UPDATE "Flight" SET "NumberOfBookedSeat"="NumberOfBookedSeat"-1;
RETURN NEW;
END;
$$;


ALTER FUNCTION public.bookedseatdecrease() OWNER TO postgres;

--
-- Name: bookedseatincrease(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.bookedseatincrease() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
UPDATE "Flight" SET "NumberOfBookedSeat"="NumberOfBookedSeat"+1;
RETURN NEW;
END;
$$;


ALTER FUNCTION public.bookedseatincrease() OWNER TO postgres;

--
-- Name: get_women_employees(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_women_employees() RETURNS TABLE("Name" character varying, "Surname" character varying, "Gender" character, "YearOfExperience" integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
  RETURN QUERY
  SELECT "Employee"."Name", "Employee"."Surname", "Employee"."Gender", "Employee"."YearOfExperience" FROM "Employee"  WHERE "Employee"."Gender" = 'W';
END;
$$;


ALTER FUNCTION public.get_women_employees() OWNER TO postgres;

--
-- Name: makefull(character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.makefull(firstname character varying, lastname character varying) RETURNS character varying
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF firstname is NULL AND lastname is NULL THEN
        RETURN NULL;
    ELSEIF firstname is NULL AND lastname is NOT NULL THEN
        RETURN lastname;
    ELSEIF firstname is NULL AND lastname is NULL THEN
        RETURN firstname;
    ELSE
        return firstname || ' ' || lastname;
    END IF;
END;
$$;


ALTER FUNCTION public.makefull(firstname character varying, lastname character varying) OWNER TO postgres;

--
-- Name: pilotdecrease(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.pilotdecrease() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
UPDATE "PlaneAgent" SET "NumberOfEmployee"="NumberOfEmployee"-1;
RETURN NEW;
END;
$$;


ALTER FUNCTION public.pilotdecrease() OWNER TO postgres;

--
-- Name: pilotincrease(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.pilotincrease() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
UPDATE "PlaneAgent" SET "NumberOfEmployee"="NumberOfEmployee"+1;
RETURN NEW;
END;
$$;


ALTER FUNCTION public.pilotincrease() OWNER TO postgres;

--
-- Name: stewardessdecrease(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.stewardessdecrease() RETURNS trigger
    LANGUAGE plpgsql
    AS $$	
BEGIN
UPDATE "PlaneAgent" SET "NumberOfEmployee"="NumberOfEmployee"-1;
RETURN NEW;
END;
$$;


ALTER FUNCTION public.stewardessdecrease() OWNER TO postgres;

--
-- Name: stewardessincrease(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.stewardessincrease() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
UPDATE "PlaneAgent" SET "NumberOfEmployee"="NumberOfEmployee"+1;
RETURN NEW;
END;
$$;


ALTER FUNCTION public.stewardessincrease() OWNER TO postgres;

--
-- Name: tax(double precision); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.tax(price double precision) RETURNS double precision
    LANGUAGE plpgsql
    AS $$
BEGIN
Price:=Price*(0.8) + Price;
RETURN Price;
END;
$$;


ALTER FUNCTION public.tax(price double precision) OWNER TO postgres;

--
-- Name: update_pilot_type(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.update_pilot_type() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  IF NEW."YearOfExperience" > 10 THEN
    NEW."PilotType" = 'C';
  ELSE
    NEW."PilotType" = 'c';
  END IF;
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.update_pilot_type() OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: Airfield; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Airfield" (
    "AirfieldID" integer NOT NULL,
    "Length" integer NOT NULL,
    "AirportID" character varying(6) NOT NULL,
    CONSTRAINT "AirfieldCheck" CHECK (("Length" > 0))
);


ALTER TABLE public."Airfield" OWNER TO postgres;

--
-- Name: Airfield_AirfieldID_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Airfield_AirfieldID_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."Airfield_AirfieldID_seq" OWNER TO postgres;

--
-- Name: Airfield_AirfieldID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Airfield_AirfieldID_seq" OWNED BY public."Airfield"."AirfieldID";


--
-- Name: Airport; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Airport" (
    "AirportID" character varying(6) NOT NULL,
    "Name" character varying(30) NOT NULL,
    "Country" character varying(30) NOT NULL,
    "City" character varying(30) NOT NULL,
    "Address" character varying(30) NOT NULL
);


ALTER TABLE public."Airport" OWNER TO postgres;

--
-- Name: Baggage; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Baggage" (
    "BaggageID" integer NOT NULL,
    "Type" character varying(15) NOT NULL,
    "Weight" integer NOT NULL,
    "PassengerID" integer NOT NULL,
    CONSTRAINT "BaggageCheck" CHECK (("Weight" > 0))
);


ALTER TABLE public."Baggage" OWNER TO postgres;

--
-- Name: Baggage_BaggageID_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Baggage_BaggageID_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."Baggage_BaggageID_seq" OWNER TO postgres;

--
-- Name: Baggage_BaggageID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Baggage_BaggageID_seq" OWNED BY public."Baggage"."BaggageID";


--
-- Name: Baggage_PassengerID_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Baggage_PassengerID_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."Baggage_PassengerID_seq" OWNER TO postgres;

--
-- Name: Baggage_PassengerID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Baggage_PassengerID_seq" OWNED BY public."Baggage"."PassengerID";


--
-- Name: BusinessTicket; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."BusinessTicket" (
    "TicketID" integer NOT NULL
);


ALTER TABLE public."BusinessTicket" OWNER TO postgres;

--
-- Name: BusinessTicket_TicketID_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."BusinessTicket_TicketID_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."BusinessTicket_TicketID_seq" OWNER TO postgres;

--
-- Name: BusinessTicket_TicketID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."BusinessTicket_TicketID_seq" OWNED BY public."BusinessTicket"."TicketID";


--
-- Name: CargoPlane; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."CargoPlane" (
    "PlaneID" integer NOT NULL,
    "Capacity" integer
);


ALTER TABLE public."CargoPlane" OWNER TO postgres;

--
-- Name: CargoPlane_PlaneID_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."CargoPlane_PlaneID_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."CargoPlane_PlaneID_seq" OWNER TO postgres;

--
-- Name: CargoPlane_PlaneID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."CargoPlane_PlaneID_seq" OWNED BY public."CargoPlane"."PlaneID";


--
-- Name: ChiefPilot; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."ChiefPilot" (
    "PilotID" integer NOT NULL
);


ALTER TABLE public."ChiefPilot" OWNER TO postgres;

--
-- Name: ChiefPilot_PilotID_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."ChiefPilot_PilotID_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."ChiefPilot_PilotID_seq" OWNER TO postgres;

--
-- Name: ChiefPilot_PilotID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."ChiefPilot_PilotID_seq" OWNED BY public."ChiefPilot"."PilotID";


--
-- Name: CleaningStaffMember; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."CleaningStaffMember" (
    "EmployeeID" integer NOT NULL,
    "Company" character varying(20) NOT NULL
);


ALTER TABLE public."CleaningStaffMember" OWNER TO postgres;

--
-- Name: CleaningStaffMember_EmployeeID_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."CleaningStaffMember_EmployeeID_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."CleaningStaffMember_EmployeeID_seq" OWNER TO postgres;

--
-- Name: CleaningStaffMember_EmployeeID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."CleaningStaffMember_EmployeeID_seq" OWNED BY public."CleaningStaffMember"."EmployeeID";


--
-- Name: Domestic; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Domestic" (
    "StewardessID" integer NOT NULL
);


ALTER TABLE public."Domestic" OWNER TO postgres;

--
-- Name: Domestic_StewardessID_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Domestic_StewardessID_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."Domestic_StewardessID_seq" OWNER TO postgres;

--
-- Name: Domestic_StewardessID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Domestic_StewardessID_seq" OWNED BY public."Domestic"."StewardessID";


--
-- Name: EconomicTicket; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."EconomicTicket" (
    "TicketID" integer NOT NULL
);


ALTER TABLE public."EconomicTicket" OWNER TO postgres;

--
-- Name: EconomicTicket_TicketID_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."EconomicTicket_TicketID_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."EconomicTicket_TicketID_seq" OWNER TO postgres;

--
-- Name: EconomicTicket_TicketID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."EconomicTicket_TicketID_seq" OWNED BY public."EconomicTicket"."TicketID";


--
-- Name: Employee; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Employee" (
    "EmployeeID" integer NOT NULL,
    "Name" character varying(50) NOT NULL,
    "Surname" character varying(50) NOT NULL,
    "Gender" character(1) NOT NULL,
    "YearOfExperience" integer,
    "AirportID" character varying(6) NOT NULL,
    "EmployeeType" character(1) NOT NULL
);


ALTER TABLE public."Employee" OWNER TO postgres;

--
-- Name: Employee_EmployeeID_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Employee_EmployeeID_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."Employee_EmployeeID_seq" OWNER TO postgres;

--
-- Name: Employee_EmployeeID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Employee_EmployeeID_seq" OWNED BY public."Employee"."EmployeeID";


--
-- Name: FireFightingPlane; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."FireFightingPlane" (
    "PlaneID" integer NOT NULL,
    "TankCapacity" integer,
    "NumberOfFireman" integer
);


ALTER TABLE public."FireFightingPlane" OWNER TO postgres;

--
-- Name: FireFightingPlane_PlaneID_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."FireFightingPlane_PlaneID_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."FireFightingPlane_PlaneID_seq" OWNER TO postgres;

--
-- Name: FireFightingPlane_PlaneID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."FireFightingPlane_PlaneID_seq" OWNED BY public."FireFightingPlane"."PlaneID";


--
-- Name: Flight; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Flight" (
    "FlightID" integer NOT NULL,
    "Date" date,
    "Hour" integer,
    "NumberOfBookedSeat" integer NOT NULL,
    "AirportID" character varying(6) NOT NULL
);


ALTER TABLE public."Flight" OWNER TO postgres;

--
-- Name: Flight_FlightID_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Flight_FlightID_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."Flight_FlightID_seq" OWNER TO postgres;

--
-- Name: Flight_FlightID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Flight_FlightID_seq" OWNED BY public."Flight"."FlightID";


--
-- Name: International; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."International" (
    "StewardessID" integer NOT NULL
);


ALTER TABLE public."International" OWNER TO postgres;

--
-- Name: International_StewardessID_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."International_StewardessID_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."International_StewardessID_seq" OWNER TO postgres;

--
-- Name: International_StewardessID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."International_StewardessID_seq" OWNED BY public."International"."StewardessID";


--
-- Name: Manager; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Manager" (
    "EmployeeID" integer NOT NULL
);


ALTER TABLE public."Manager" OWNER TO postgres;

--
-- Name: Manager_EmployeeID_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Manager_EmployeeID_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."Manager_EmployeeID_seq" OWNER TO postgres;

--
-- Name: Manager_EmployeeID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Manager_EmployeeID_seq" OWNED BY public."Manager"."EmployeeID";


--
-- Name: MilitaryPlane; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."MilitaryPlane" (
    "PlaneID" integer NOT NULL,
    "Equipment" boolean NOT NULL,
    "NumberOfSeat" integer,
    "NumberOfMilitary" integer
);


ALTER TABLE public."MilitaryPlane" OWNER TO postgres;

--
-- Name: MilitaryPlane_PlaneID_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."MilitaryPlane_PlaneID_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."MilitaryPlane_PlaneID_seq" OWNER TO postgres;

--
-- Name: MilitaryPlane_PlaneID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."MilitaryPlane_PlaneID_seq" OWNED BY public."MilitaryPlane"."PlaneID";


--
-- Name: PassangerPlane; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."PassangerPlane" (
    "PlaneID" integer NOT NULL,
    "NumberOfStewardess" integer,
    "NumberOfSeat" integer,
    "PlaneAgentID" integer NOT NULL
);


ALTER TABLE public."PassangerPlane" OWNER TO postgres;

--
-- Name: PassangerPlaneStewardess; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."PassangerPlaneStewardess" (
    "PlaneID" integer NOT NULL,
    "StewardessID" integer NOT NULL
);


ALTER TABLE public."PassangerPlaneStewardess" OWNER TO postgres;

--
-- Name: PassangerPlaneStewardess_PlaneID_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."PassangerPlaneStewardess_PlaneID_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."PassangerPlaneStewardess_PlaneID_seq" OWNER TO postgres;

--
-- Name: PassangerPlaneStewardess_PlaneID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."PassangerPlaneStewardess_PlaneID_seq" OWNED BY public."PassangerPlaneStewardess"."PlaneID";


--
-- Name: PassangerPlaneStewardess_StewardessID_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."PassangerPlaneStewardess_StewardessID_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."PassangerPlaneStewardess_StewardessID_seq" OWNER TO postgres;

--
-- Name: PassangerPlaneStewardess_StewardessID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."PassangerPlaneStewardess_StewardessID_seq" OWNED BY public."PassangerPlaneStewardess"."StewardessID";


--
-- Name: PassangerPlane_PlaneID_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."PassangerPlane_PlaneID_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."PassangerPlane_PlaneID_seq" OWNER TO postgres;

--
-- Name: PassangerPlane_PlaneID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."PassangerPlane_PlaneID_seq" OWNED BY public."PassangerPlane"."PlaneID";


--
-- Name: Passenger; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Passenger" (
    "PassengerID" integer NOT NULL,
    "Name" character varying(50) NOT NULL,
    "Surname" character varying(50) NOT NULL,
    "Gender" character(1) NOT NULL,
    "Age" integer NOT NULL,
    "IdentityNumber" character varying(11) NOT NULL,
    CONSTRAINT "PassengerCheck2" CHECK (("Age" >= 0))
);


ALTER TABLE public."Passenger" OWNER TO postgres;

--
-- Name: PassengerServiceOfficer; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."PassengerServiceOfficer" (
    "EmployeeID" integer NOT NULL,
    "WorkArea" character varying(15) NOT NULL
);


ALTER TABLE public."PassengerServiceOfficer" OWNER TO postgres;

--
-- Name: PassengerServiceOfficer_EmployeeID_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."PassengerServiceOfficer_EmployeeID_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."PassengerServiceOfficer_EmployeeID_seq" OWNER TO postgres;

--
-- Name: PassengerServiceOfficer_EmployeeID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."PassengerServiceOfficer_EmployeeID_seq" OWNED BY public."PassengerServiceOfficer"."EmployeeID";


--
-- Name: Passenger_PassengerID_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Passenger_PassengerID_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."Passenger_PassengerID_seq" OWNER TO postgres;

--
-- Name: Passenger_PassengerID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Passenger_PassengerID_seq" OWNED BY public."Passenger"."PassengerID";


--
-- Name: Pilot; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Pilot" (
    "PilotID" integer NOT NULL,
    "Name" character varying(50) NOT NULL,
    "Surname" character varying(50) NOT NULL,
    "Gender" character(1) NOT NULL,
    "YearOfExperience" integer,
    "PlaneAgentID" integer NOT NULL,
    "PilotType" character(1) NOT NULL
);


ALTER TABLE public."Pilot" OWNER TO postgres;

--
-- Name: Pilot_PilotID_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Pilot_PilotID_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."Pilot_PilotID_seq" OWNER TO postgres;

--
-- Name: Pilot_PilotID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Pilot_PilotID_seq" OWNED BY public."Pilot"."PilotID";


--
-- Name: Plane; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Plane" (
    "PlaneID" integer NOT NULL,
    "BladeType" character varying(50) NOT NULL,
    "EngineType" character varying(50) NOT NULL,
    "FeulType" character varying(50) NOT NULL,
    "Weight" integer NOT NULL,
    "AirportID" character varying(6) NOT NULL,
    "PlaneType" character(1) NOT NULL
);


ALTER TABLE public."Plane" OWNER TO postgres;

--
-- Name: PlaneAgent; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."PlaneAgent" (
    "PlaneAgentID" integer NOT NULL,
    "Name" character varying(30) NOT NULL,
    "NumberOfPlane" integer,
    "NumberOfEmployee" integer
);


ALTER TABLE public."PlaneAgent" OWNER TO postgres;

--
-- Name: PlanePilot; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."PlanePilot" (
    "PlaneID" integer NOT NULL,
    "PilotID" integer NOT NULL
);


ALTER TABLE public."PlanePilot" OWNER TO postgres;

--
-- Name: PlanePilot_PilotID_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."PlanePilot_PilotID_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."PlanePilot_PilotID_seq" OWNER TO postgres;

--
-- Name: PlanePilot_PilotID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."PlanePilot_PilotID_seq" OWNED BY public."PlanePilot"."PilotID";


--
-- Name: PlanePilot_PlaneID_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."PlanePilot_PlaneID_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."PlanePilot_PlaneID_seq" OWNER TO postgres;

--
-- Name: PlanePilot_PlaneID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."PlanePilot_PlaneID_seq" OWNED BY public."PlanePilot"."PlaneID";


--
-- Name: Plane_PlaneID_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Plane_PlaneID_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."Plane_PlaneID_seq" OWNER TO postgres;

--
-- Name: Plane_PlaneID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Plane_PlaneID_seq" OWNED BY public."Plane"."PlaneID";


--
-- Name: Security; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Security" (
    "EmployeeID" integer NOT NULL,
    "UseGun" boolean NOT NULL
);


ALTER TABLE public."Security" OWNER TO postgres;

--
-- Name: Security_EmployeeID_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Security_EmployeeID_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."Security_EmployeeID_seq" OWNER TO postgres;

--
-- Name: Security_EmployeeID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Security_EmployeeID_seq" OWNED BY public."Security"."EmployeeID";


--
-- Name: Stewardess; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Stewardess" (
    "StewardessID" integer NOT NULL,
    "Name" character varying(50) NOT NULL,
    "Surname" character varying(50) NOT NULL,
    "Gender" character(1) NOT NULL,
    "YearOfExperience" integer,
    "PlaneAgentID" integer NOT NULL,
    "StewardessType" character(1) NOT NULL
);


ALTER TABLE public."Stewardess" OWNER TO postgres;

--
-- Name: Stewardess_StewardessID_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Stewardess_StewardessID_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."Stewardess_StewardessID_seq" OWNER TO postgres;

--
-- Name: Stewardess_StewardessID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Stewardess_StewardessID_seq" OWNED BY public."Stewardess"."StewardessID";


--
-- Name: Ticket; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Ticket" (
    "TicketID" integer NOT NULL,
    "SeatNumber" character varying(3) NOT NULL,
    "Price" integer NOT NULL,
    "PassengerID" integer NOT NULL,
    "FlightID" integer NOT NULL,
    "TicketType" character(1) NOT NULL
);


ALTER TABLE public."Ticket" OWNER TO postgres;

--
-- Name: Ticket_FlightID_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Ticket_FlightID_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."Ticket_FlightID_seq" OWNER TO postgres;

--
-- Name: Ticket_FlightID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Ticket_FlightID_seq" OWNED BY public."Ticket"."FlightID";


--
-- Name: Ticket_PassengerID_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Ticket_PassengerID_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."Ticket_PassengerID_seq" OWNER TO postgres;

--
-- Name: Ticket_PassengerID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Ticket_PassengerID_seq" OWNED BY public."Ticket"."PassengerID";


--
-- Name: Ticket_TicketID_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Ticket_TicketID_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."Ticket_TicketID_seq" OWNER TO postgres;

--
-- Name: Ticket_TicketID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Ticket_TicketID_seq" OWNED BY public."Ticket"."TicketID";


--
-- Name: co-Pilot; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."co-Pilot" (
    "PilotID" integer NOT NULL
);


ALTER TABLE public."co-Pilot" OWNER TO postgres;

--
-- Name: co-Pilot_PilotID_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."co-Pilot_PilotID_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."co-Pilot_PilotID_seq" OWNER TO postgres;

--
-- Name: co-Pilot_PilotID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."co-Pilot_PilotID_seq" OWNED BY public."co-Pilot"."PilotID";


--
-- Name: Airfield AirfieldID; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Airfield" ALTER COLUMN "AirfieldID" SET DEFAULT nextval('public."Airfield_AirfieldID_seq"'::regclass);


--
-- Name: Baggage BaggageID; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Baggage" ALTER COLUMN "BaggageID" SET DEFAULT nextval('public."Baggage_BaggageID_seq"'::regclass);


--
-- Name: Baggage PassengerID; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Baggage" ALTER COLUMN "PassengerID" SET DEFAULT nextval('public."Baggage_PassengerID_seq"'::regclass);


--
-- Name: BusinessTicket TicketID; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."BusinessTicket" ALTER COLUMN "TicketID" SET DEFAULT nextval('public."BusinessTicket_TicketID_seq"'::regclass);


--
-- Name: CargoPlane PlaneID; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."CargoPlane" ALTER COLUMN "PlaneID" SET DEFAULT nextval('public."CargoPlane_PlaneID_seq"'::regclass);


--
-- Name: ChiefPilot PilotID; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."ChiefPilot" ALTER COLUMN "PilotID" SET DEFAULT nextval('public."ChiefPilot_PilotID_seq"'::regclass);


--
-- Name: CleaningStaffMember EmployeeID; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."CleaningStaffMember" ALTER COLUMN "EmployeeID" SET DEFAULT nextval('public."CleaningStaffMember_EmployeeID_seq"'::regclass);


--
-- Name: Domestic StewardessID; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Domestic" ALTER COLUMN "StewardessID" SET DEFAULT nextval('public."Domestic_StewardessID_seq"'::regclass);


--
-- Name: EconomicTicket TicketID; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."EconomicTicket" ALTER COLUMN "TicketID" SET DEFAULT nextval('public."EconomicTicket_TicketID_seq"'::regclass);


--
-- Name: Employee EmployeeID; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Employee" ALTER COLUMN "EmployeeID" SET DEFAULT nextval('public."Employee_EmployeeID_seq"'::regclass);


--
-- Name: FireFightingPlane PlaneID; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."FireFightingPlane" ALTER COLUMN "PlaneID" SET DEFAULT nextval('public."FireFightingPlane_PlaneID_seq"'::regclass);


--
-- Name: Flight FlightID; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Flight" ALTER COLUMN "FlightID" SET DEFAULT nextval('public."Flight_FlightID_seq"'::regclass);


--
-- Name: International StewardessID; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."International" ALTER COLUMN "StewardessID" SET DEFAULT nextval('public."International_StewardessID_seq"'::regclass);


--
-- Name: Manager EmployeeID; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Manager" ALTER COLUMN "EmployeeID" SET DEFAULT nextval('public."Manager_EmployeeID_seq"'::regclass);


--
-- Name: MilitaryPlane PlaneID; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."MilitaryPlane" ALTER COLUMN "PlaneID" SET DEFAULT nextval('public."MilitaryPlane_PlaneID_seq"'::regclass);


--
-- Name: PassangerPlane PlaneID; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."PassangerPlane" ALTER COLUMN "PlaneID" SET DEFAULT nextval('public."PassangerPlane_PlaneID_seq"'::regclass);


--
-- Name: PassangerPlaneStewardess PlaneID; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."PassangerPlaneStewardess" ALTER COLUMN "PlaneID" SET DEFAULT nextval('public."PassangerPlaneStewardess_PlaneID_seq"'::regclass);


--
-- Name: PassangerPlaneStewardess StewardessID; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."PassangerPlaneStewardess" ALTER COLUMN "StewardessID" SET DEFAULT nextval('public."PassangerPlaneStewardess_StewardessID_seq"'::regclass);


--
-- Name: Passenger PassengerID; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Passenger" ALTER COLUMN "PassengerID" SET DEFAULT nextval('public."Passenger_PassengerID_seq"'::regclass);


--
-- Name: PassengerServiceOfficer EmployeeID; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."PassengerServiceOfficer" ALTER COLUMN "EmployeeID" SET DEFAULT nextval('public."PassengerServiceOfficer_EmployeeID_seq"'::regclass);


--
-- Name: Pilot PilotID; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Pilot" ALTER COLUMN "PilotID" SET DEFAULT nextval('public."Pilot_PilotID_seq"'::regclass);


--
-- Name: Plane PlaneID; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Plane" ALTER COLUMN "PlaneID" SET DEFAULT nextval('public."Plane_PlaneID_seq"'::regclass);


--
-- Name: PlanePilot PlaneID; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."PlanePilot" ALTER COLUMN "PlaneID" SET DEFAULT nextval('public."PlanePilot_PlaneID_seq"'::regclass);


--
-- Name: PlanePilot PilotID; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."PlanePilot" ALTER COLUMN "PilotID" SET DEFAULT nextval('public."PlanePilot_PilotID_seq"'::regclass);


--
-- Name: Security EmployeeID; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Security" ALTER COLUMN "EmployeeID" SET DEFAULT nextval('public."Security_EmployeeID_seq"'::regclass);


--
-- Name: Stewardess StewardessID; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Stewardess" ALTER COLUMN "StewardessID" SET DEFAULT nextval('public."Stewardess_StewardessID_seq"'::regclass);


--
-- Name: Ticket TicketID; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Ticket" ALTER COLUMN "TicketID" SET DEFAULT nextval('public."Ticket_TicketID_seq"'::regclass);


--
-- Name: Ticket PassengerID; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Ticket" ALTER COLUMN "PassengerID" SET DEFAULT nextval('public."Ticket_PassengerID_seq"'::regclass);


--
-- Name: Ticket FlightID; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Ticket" ALTER COLUMN "FlightID" SET DEFAULT nextval('public."Ticket_FlightID_seq"'::regclass);


--
-- Name: co-Pilot PilotID; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."co-Pilot" ALTER COLUMN "PilotID" SET DEFAULT nextval('public."co-Pilot_PilotID_seq"'::regclass);


--
-- Data for Name: Airfield; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public."Airfield" VALUES
	(1, 1500, 'MER040');


--
-- Data for Name: Airport; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public."Airport" VALUES
	('MER040', 'MerSin Airport', 'Türkiye', 'Mersin', 'Erdemli mah. Fatih blv.');


--
-- Data for Name: Baggage; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public."Baggage" VALUES
	(1, 'Cabin', 5, 1),
	(2, 'Cargo', 20, 2),
	(3, 'Cargo', 23, 2);


--
-- Data for Name: BusinessTicket; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: CargoPlane; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public."CargoPlane" VALUES
	(3, 200);


--
-- Data for Name: ChiefPilot; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public."ChiefPilot" VALUES
	(1);


--
-- Data for Name: CleaningStaffMember; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public."CleaningStaffMember" VALUES
	(4, 'Shine Cleaning');


--
-- Data for Name: Domestic; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public."Domestic" VALUES
	(1);


--
-- Data for Name: EconomicTicket; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public."EconomicTicket" VALUES
	(1);


--
-- Data for Name: Employee; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public."Employee" VALUES
	(1, 'Mahmut', 'Tuncer', 'M', 27, 'MER040', 'M'),
	(2, 'Hayko', 'Cepkin', 'M', 17, 'MER040', 'S'),
	(3, 'Safiye', 'Soyman', 'W', 12, 'MER040', 'P'),
	(4, 'Feyre', 'Archeron', 'W', 4, 'MER040', 'C');


--
-- Data for Name: FireFightingPlane; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public."FireFightingPlane" VALUES
	(2, 8, 9);


--
-- Data for Name: Flight; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public."Flight" VALUES
	(1, '2022-12-22', 12, 460, 'MER040');


--
-- Data for Name: International; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public."International" VALUES
	(2);


--
-- Data for Name: Manager; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public."Manager" VALUES
	(1);


--
-- Data for Name: MilitaryPlane; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public."MilitaryPlane" VALUES
	(1, true, 32, 18);


--
-- Data for Name: PassangerPlane; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public."PassangerPlane" VALUES
	(4, 3, 500, 1);


--
-- Data for Name: PassangerPlaneStewardess; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public."PassangerPlaneStewardess" VALUES
	(4, 1),
	(4, 2);


--
-- Data for Name: Passenger; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public."Passenger" VALUES
	(1, 'Sinem', 'Taşdemir', 'W', 21, '23456789101'),
	(2, 'Merve', 'Ağaçayak', 'W', 20, '12345678910'),
	(3, 'Ayşe', 'Bulut', 'W', 4, '67434234891');


--
-- Data for Name: PassengerServiceOfficer; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public."PassengerServiceOfficer" VALUES
	(3, 'PassportControl');


--
-- Data for Name: Pilot; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public."Pilot" VALUES
	(1, 'Şahin', 'Uçar', 'M', 13, 1, 'C'),
	(2, 'Kasım', 'Gerik', 'M', 23, 1, 'C');


--
-- Data for Name: Plane; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public."Plane" VALUES
	(1, 'Bird Blade', 'Strong Engine', 'Carbon', 475, 'MER040', 'M'),
	(2, 'Sharp Blade', 'Honku Engine', 'Parphine', 378, 'MER040', 'F'),
	(3, 'Smooth Blade', 'Hankim Engine', 'Karosen', 500, 'MER040', 'C'),
	(4, 'Sholder Blade', 'Strong Engine', 'Carbon', 510, 'MER040', 'P');


--
-- Data for Name: PlaneAgent; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public."PlaneAgent" VALUES
	(1, 'SinAir', 200, 3000);


--
-- Data for Name: PlanePilot; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public."PlanePilot" VALUES
	(1, 1),
	(1, 2);


--
-- Data for Name: Security; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public."Security" VALUES
	(2, true);


--
-- Data for Name: Stewardess; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public."Stewardess" VALUES
	(1, 'Buse', 'Nazlı', 'W', 4, 1, 'D'),
	(2, 'Neslihan', 'Koçbaşı', 'W', 7, 1, 'I');


--
-- Data for Name: Ticket; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public."Ticket" VALUES
	(1, '32B', 150, 1, 1, 'E'),
	(2, '5B', 350, 2, 1, 'B'),
	(3, '22B', 150, 3, 1, 'E');


--
-- Data for Name: co-Pilot; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public."co-Pilot" VALUES
	(2);


--
-- Name: Airfield_AirfieldID_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Airfield_AirfieldID_seq"', 1, false);


--
-- Name: Baggage_BaggageID_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Baggage_BaggageID_seq"', 1, false);


--
-- Name: Baggage_PassengerID_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Baggage_PassengerID_seq"', 1, false);


--
-- Name: BusinessTicket_TicketID_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."BusinessTicket_TicketID_seq"', 1, false);


--
-- Name: CargoPlane_PlaneID_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."CargoPlane_PlaneID_seq"', 1, false);


--
-- Name: ChiefPilot_PilotID_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."ChiefPilot_PilotID_seq"', 1, false);


--
-- Name: CleaningStaffMember_EmployeeID_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."CleaningStaffMember_EmployeeID_seq"', 1, false);


--
-- Name: Domestic_StewardessID_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Domestic_StewardessID_seq"', 1, false);


--
-- Name: EconomicTicket_TicketID_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."EconomicTicket_TicketID_seq"', 1, false);


--
-- Name: Employee_EmployeeID_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Employee_EmployeeID_seq"', 1, false);


--
-- Name: FireFightingPlane_PlaneID_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."FireFightingPlane_PlaneID_seq"', 1, false);


--
-- Name: Flight_FlightID_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Flight_FlightID_seq"', 1, false);


--
-- Name: International_StewardessID_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."International_StewardessID_seq"', 1, false);


--
-- Name: Manager_EmployeeID_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Manager_EmployeeID_seq"', 1, false);


--
-- Name: MilitaryPlane_PlaneID_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."MilitaryPlane_PlaneID_seq"', 1, false);


--
-- Name: PassangerPlaneStewardess_PlaneID_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."PassangerPlaneStewardess_PlaneID_seq"', 1, false);


--
-- Name: PassangerPlaneStewardess_StewardessID_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."PassangerPlaneStewardess_StewardessID_seq"', 1, false);


--
-- Name: PassangerPlane_PlaneID_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."PassangerPlane_PlaneID_seq"', 1, false);


--
-- Name: PassengerServiceOfficer_EmployeeID_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."PassengerServiceOfficer_EmployeeID_seq"', 1, false);


--
-- Name: Passenger_PassengerID_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Passenger_PassengerID_seq"', 1, false);


--
-- Name: Pilot_PilotID_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Pilot_PilotID_seq"', 10, true);


--
-- Name: PlanePilot_PilotID_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."PlanePilot_PilotID_seq"', 1, false);


--
-- Name: PlanePilot_PlaneID_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."PlanePilot_PlaneID_seq"', 1, false);


--
-- Name: Plane_PlaneID_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Plane_PlaneID_seq"', 1, false);


--
-- Name: Security_EmployeeID_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Security_EmployeeID_seq"', 1, false);


--
-- Name: Stewardess_StewardessID_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Stewardess_StewardessID_seq"', 1, false);


--
-- Name: Ticket_FlightID_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Ticket_FlightID_seq"', 1, false);


--
-- Name: Ticket_PassengerID_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Ticket_PassengerID_seq"', 1, false);


--
-- Name: Ticket_TicketID_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Ticket_TicketID_seq"', 1, false);


--
-- Name: co-Pilot_PilotID_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."co-Pilot_PilotID_seq"', 1, false);


--
-- Name: Airfield AirfieldPK; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Airfield"
    ADD CONSTRAINT "AirfieldPK" PRIMARY KEY ("AirfieldID");


--
-- Name: Airport AirportPK; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Airport"
    ADD CONSTRAINT "AirportPK" PRIMARY KEY ("AirportID");


--
-- Name: Baggage BaggagePK; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Baggage"
    ADD CONSTRAINT "BaggagePK" PRIMARY KEY ("BaggageID");


--
-- Name: BusinessTicket BusinessTicketPK; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."BusinessTicket"
    ADD CONSTRAINT "BusinessTicketPK" PRIMARY KEY ("TicketID");


--
-- Name: CargoPlane CargoPlanePK; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."CargoPlane"
    ADD CONSTRAINT "CargoPlanePK" PRIMARY KEY ("PlaneID");


--
-- Name: ChiefPilot ChiefPilotPK; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."ChiefPilot"
    ADD CONSTRAINT "ChiefPilotPK" PRIMARY KEY ("PilotID");


--
-- Name: CleaningStaffMember CleaningStaffMemberPK; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."CleaningStaffMember"
    ADD CONSTRAINT "CleaningStaffMemberPK" PRIMARY KEY ("EmployeeID");


--
-- Name: Domestic DomesticPK; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Domestic"
    ADD CONSTRAINT "DomesticPK" PRIMARY KEY ("StewardessID");


--
-- Name: EconomicTicket EconomicTicketPK; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."EconomicTicket"
    ADD CONSTRAINT "EconomicTicketPK" PRIMARY KEY ("TicketID");


--
-- Name: Employee EmployeePK; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Employee"
    ADD CONSTRAINT "EmployeePK" PRIMARY KEY ("EmployeeID");


--
-- Name: FireFightingPlane FireFightingPlanePK; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."FireFightingPlane"
    ADD CONSTRAINT "FireFightingPlanePK" PRIMARY KEY ("PlaneID");


--
-- Name: Flight FlightPK; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Flight"
    ADD CONSTRAINT "FlightPK" PRIMARY KEY ("FlightID");


--
-- Name: International InternationalPK; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."International"
    ADD CONSTRAINT "InternationalPK" PRIMARY KEY ("StewardessID");


--
-- Name: Manager ManagerPK; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Manager"
    ADD CONSTRAINT "ManagerPK" PRIMARY KEY ("EmployeeID");


--
-- Name: MilitaryPlane MilitaryPlanePK; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."MilitaryPlane"
    ADD CONSTRAINT "MilitaryPlanePK" PRIMARY KEY ("PlaneID");


--
-- Name: PassangerPlane PassangerPlanePK; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."PassangerPlane"
    ADD CONSTRAINT "PassangerPlanePK" PRIMARY KEY ("PlaneID");


--
-- Name: PassangerPlaneStewardess PassangerPlaneStewardessPK; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."PassangerPlaneStewardess"
    ADD CONSTRAINT "PassangerPlaneStewardessPK" PRIMARY KEY ("StewardessID", "PlaneID");


--
-- Name: Passenger PassengerPK; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Passenger"
    ADD CONSTRAINT "PassengerPK" PRIMARY KEY ("PassengerID");


--
-- Name: PassengerServiceOfficer PassengerServiceOfficerPK; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."PassengerServiceOfficer"
    ADD CONSTRAINT "PassengerServiceOfficerPK" PRIMARY KEY ("EmployeeID");


--
-- Name: Pilot PilotPK; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Pilot"
    ADD CONSTRAINT "PilotPK" PRIMARY KEY ("PilotID");


--
-- Name: PlaneAgent PlaneAgentID; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."PlaneAgent"
    ADD CONSTRAINT "PlaneAgentID" PRIMARY KEY ("PlaneAgentID");


--
-- Name: Plane PlanePK; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Plane"
    ADD CONSTRAINT "PlanePK" PRIMARY KEY ("PlaneID");


--
-- Name: PlanePilot PlanePilotPK; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."PlanePilot"
    ADD CONSTRAINT "PlanePilotPK" PRIMARY KEY ("PilotID", "PlaneID");


--
-- Name: Security SecurityPK; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Security"
    ADD CONSTRAINT "SecurityPK" PRIMARY KEY ("EmployeeID");


--
-- Name: Stewardess StewardessPK; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Stewardess"
    ADD CONSTRAINT "StewardessPK" PRIMARY KEY ("StewardessID");


--
-- Name: Ticket TicketPK; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Ticket"
    ADD CONSTRAINT "TicketPK" PRIMARY KEY ("TicketID");


--
-- Name: co-Pilot co-PilotPK; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."co-Pilot"
    ADD CONSTRAINT "co-PilotPK" PRIMARY KEY ("PilotID");


--
-- Name: Pilot trig2pilot; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trig2pilot AFTER DELETE ON public."Pilot" FOR EACH ROW EXECUTE FUNCTION public.pilotdecrease();


--
-- Name: Stewardess trig2stewardess; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trig2stewardess AFTER DELETE ON public."Stewardess" FOR EACH ROW EXECUTE FUNCTION public.stewardessdecrease();


--
-- Name: Ticket trig2ticket; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trig2ticket AFTER DELETE ON public."Ticket" FOR EACH ROW EXECUTE FUNCTION public.bookedseatdecrease();


--
-- Name: Pilot trigpilot; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trigpilot AFTER INSERT ON public."Pilot" FOR EACH ROW EXECUTE FUNCTION public.pilotincrease();


--
-- Name: Stewardess trigstewardess; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trigstewardess AFTER INSERT ON public."Stewardess" FOR EACH ROW EXECUTE FUNCTION public.stewardessincrease();


--
-- Name: Ticket trigticket; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trigticket AFTER INSERT ON public."Ticket" FOR EACH ROW EXECUTE FUNCTION public.bookedseatincrease();


--
-- Name: Pilot update_pilot_type_trigger; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_pilot_type_trigger BEFORE UPDATE OF "YearOfExperience" ON public."Pilot" FOR EACH ROW EXECUTE FUNCTION public.update_pilot_type();


--
-- Name: Airfield AirfieldFK; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Airfield"
    ADD CONSTRAINT "AirfieldFK" FOREIGN KEY ("AirportID") REFERENCES public."Airport"("AirportID");


--
-- Name: Baggage BaggageFK; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Baggage"
    ADD CONSTRAINT "BaggageFK" FOREIGN KEY ("PassengerID") REFERENCES public."Passenger"("PassengerID");


--
-- Name: BusinessTicket BusinessTicketTicket; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."BusinessTicket"
    ADD CONSTRAINT "BusinessTicketTicket" FOREIGN KEY ("TicketID") REFERENCES public."Ticket"("TicketID") ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: CargoPlane CargoPlanePlane; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."CargoPlane"
    ADD CONSTRAINT "CargoPlanePlane" FOREIGN KEY ("PlaneID") REFERENCES public."Plane"("PlaneID") ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: ChiefPilot ChiefPilotPilot; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."ChiefPilot"
    ADD CONSTRAINT "ChiefPilotPilot" FOREIGN KEY ("PilotID") REFERENCES public."Pilot"("PilotID") ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: CleaningStaffMember CleaningStaffMemberEmployee; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."CleaningStaffMember"
    ADD CONSTRAINT "CleaningStaffMemberEmployee" FOREIGN KEY ("EmployeeID") REFERENCES public."Employee"("EmployeeID") ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: Domestic DomesticStewardess; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Domestic"
    ADD CONSTRAINT "DomesticStewardess" FOREIGN KEY ("StewardessID") REFERENCES public."Stewardess"("StewardessID") ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: EconomicTicket EconomicTicketTicket; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."EconomicTicket"
    ADD CONSTRAINT "EconomicTicketTicket" FOREIGN KEY ("TicketID") REFERENCES public."Ticket"("TicketID") ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: Employee EmployeeFK; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Employee"
    ADD CONSTRAINT "EmployeeFK" FOREIGN KEY ("AirportID") REFERENCES public."Airport"("AirportID");


--
-- Name: FireFightingPlane FireFightingPlanePlane; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."FireFightingPlane"
    ADD CONSTRAINT "FireFightingPlanePlane" FOREIGN KEY ("PlaneID") REFERENCES public."Plane"("PlaneID") ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: Flight FlightFK; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Flight"
    ADD CONSTRAINT "FlightFK" FOREIGN KEY ("AirportID") REFERENCES public."Airport"("AirportID");


--
-- Name: International InternationalStewardess; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."International"
    ADD CONSTRAINT "InternationalStewardess" FOREIGN KEY ("StewardessID") REFERENCES public."Stewardess"("StewardessID") ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: Manager ManagerEmployee; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Manager"
    ADD CONSTRAINT "ManagerEmployee" FOREIGN KEY ("EmployeeID") REFERENCES public."Employee"("EmployeeID") ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: MilitaryPlane MilitaryPlanePlane; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."MilitaryPlane"
    ADD CONSTRAINT "MilitaryPlanePlane" FOREIGN KEY ("PlaneID") REFERENCES public."Plane"("PlaneID") ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: PassangerPlane PassangerPlaneFK; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."PassangerPlane"
    ADD CONSTRAINT "PassangerPlaneFK" FOREIGN KEY ("PlaneAgentID") REFERENCES public."PlaneAgent"("PlaneAgentID") ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: PassangerPlane PassangerPlanePlane; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."PassangerPlane"
    ADD CONSTRAINT "PassangerPlanePlane" FOREIGN KEY ("PlaneID") REFERENCES public."Plane"("PlaneID");


--
-- Name: PassangerPlaneStewardess PassangerPlaneStewardessFK; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."PassangerPlaneStewardess"
    ADD CONSTRAINT "PassangerPlaneStewardessFK" FOREIGN KEY ("StewardessID") REFERENCES public."Stewardess"("StewardessID") ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: PassangerPlaneStewardess PassangerPlaneStewardessFK2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."PassangerPlaneStewardess"
    ADD CONSTRAINT "PassangerPlaneStewardessFK2" FOREIGN KEY ("PlaneID") REFERENCES public."PassangerPlane"("PlaneID") ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: PassengerServiceOfficer PassengerServiceOfficerEmployee; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."PassengerServiceOfficer"
    ADD CONSTRAINT "PassengerServiceOfficerEmployee" FOREIGN KEY ("EmployeeID") REFERENCES public."Employee"("EmployeeID") ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: Pilot PilotFK; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Pilot"
    ADD CONSTRAINT "PilotFK" FOREIGN KEY ("PlaneAgentID") REFERENCES public."PlaneAgent"("PlaneAgentID");


--
-- Name: Plane PlaneFK; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Plane"
    ADD CONSTRAINT "PlaneFK" FOREIGN KEY ("AirportID") REFERENCES public."Airport"("AirportID");


--
-- Name: PlanePilot PlanePilotFK; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."PlanePilot"
    ADD CONSTRAINT "PlanePilotFK" FOREIGN KEY ("PilotID") REFERENCES public."Pilot"("PilotID") ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: PlanePilot PlanePilotFK2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."PlanePilot"
    ADD CONSTRAINT "PlanePilotFK2" FOREIGN KEY ("PlaneID") REFERENCES public."Plane"("PlaneID") ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: Security SecurityEmployee; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Security"
    ADD CONSTRAINT "SecurityEmployee" FOREIGN KEY ("EmployeeID") REFERENCES public."Employee"("EmployeeID") ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: Stewardess StewardessFK; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Stewardess"
    ADD CONSTRAINT "StewardessFK" FOREIGN KEY ("PlaneAgentID") REFERENCES public."PlaneAgent"("PlaneAgentID");


--
-- Name: Ticket TicketFK; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Ticket"
    ADD CONSTRAINT "TicketFK" FOREIGN KEY ("PassengerID") REFERENCES public."Passenger"("PassengerID");


--
-- Name: Ticket TicketFK2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Ticket"
    ADD CONSTRAINT "TicketFK2" FOREIGN KEY ("FlightID") REFERENCES public."Flight"("FlightID");


--
-- Name: co-Pilot co-PilotPilot; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."co-Pilot"
    ADD CONSTRAINT "co-PilotPilot" FOREIGN KEY ("PilotID") REFERENCES public."Pilot"("PilotID") ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE USAGE ON SCHEMA public FROM PUBLIC;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--

