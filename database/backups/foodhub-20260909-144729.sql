--
-- PostgreSQL database dump
--

\restrict YAHaBs9OpdB4xsBGJCzJH3sbaa2gpoWBW49jFazXaeJWITFmaxfVyWB7IjiJh1z

-- Dumped from database version 17.7
-- Dumped by pg_dump version 17.7

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: cart_items; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cart_items (
    id bigint NOT NULL,
    created_at timestamp(6) without time zone,
    price numeric(10,2) NOT NULL,
    quantity integer NOT NULL,
    updated_at timestamp(6) without time zone,
    cart_id bigint NOT NULL,
    food_id bigint NOT NULL
);


ALTER TABLE public.cart_items OWNER TO postgres;

--
-- Name: cart_items_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.cart_items_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.cart_items_id_seq OWNER TO postgres;

--
-- Name: cart_items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.cart_items_id_seq OWNED BY public.cart_items.id;


--
-- Name: carts; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.carts (
    id bigint NOT NULL,
    created_at timestamp(6) without time zone,
    updated_at timestamp(6) without time zone,
    customer_id bigint NOT NULL
);


ALTER TABLE public.carts OWNER TO postgres;

--
-- Name: carts_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.carts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.carts_id_seq OWNER TO postgres;

--
-- Name: carts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.carts_id_seq OWNED BY public.carts.id;


--
-- Name: foods; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.foods (
    id bigint NOT NULL,
    availability boolean NOT NULL,
    category character varying(255),
    created_at timestamp(6) without time zone,
    description text,
    image_url character varying(255),
    name character varying(255) NOT NULL,
    price numeric(10,2) NOT NULL,
    updated_at timestamp(6) without time zone,
    shop_id bigint NOT NULL,
    prep_time_minutes integer,
    CONSTRAINT foods_category_check CHECK (((category)::text = ANY ((ARRAY['BREAKFAST'::character varying, 'LUNCH'::character varying, 'DINNER'::character varying, 'SNACKS'::character varying, 'BEVERAGES'::character varying, 'FAST_FOOD'::character varying, 'DESSERTS'::character varying])::text[])))
);


ALTER TABLE public.foods OWNER TO postgres;

--
-- Name: foods_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.foods_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.foods_id_seq OWNER TO postgres;

--
-- Name: foods_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.foods_id_seq OWNED BY public.foods.id;


--
-- Name: order_items; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.order_items (
    id bigint NOT NULL,
    created_at timestamp(6) without time zone,
    food_name character varying(255) NOT NULL,
    item_status character varying(255),
    price numeric(10,2) NOT NULL,
    quantity integer NOT NULL,
    food_id bigint,
    order_id bigint NOT NULL,
    shop_id bigint,
    CONSTRAINT order_items_item_status_check CHECK (((item_status)::text = ANY ((ARRAY['PENDING'::character varying, 'ACCEPTED'::character varying, 'REJECTED'::character varying, 'COMPLETED'::character varying])::text[])))
);


ALTER TABLE public.order_items OWNER TO postgres;

--
-- Name: order_items_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.order_items_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.order_items_id_seq OWNER TO postgres;

--
-- Name: order_items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.order_items_id_seq OWNED BY public.order_items.id;


--
-- Name: orders; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.orders (
    id bigint NOT NULL,
    created_at timestamp(6) without time zone,
    order_status character varying(255) NOT NULL,
    payment_status character varying(255) NOT NULL,
    total_amount numeric(10,2) NOT NULL,
    updated_at timestamp(6) without time zone,
    customer_id bigint NOT NULL,
    completed_at timestamp(6) without time zone,
    estimated_prep_minutes integer,
    fulfillment_status character varying(255) DEFAULT 'ORDER_PLACED'::character varying NOT NULL,
    placed_at timestamp(6) without time zone,
    preparing_at timestamp(6) without time zone,
    ready_at timestamp(6) without time zone,
    CONSTRAINT orders_fulfillment_status_check CHECK (((fulfillment_status)::text = ANY ((ARRAY['ORDER_PLACED'::character varying, 'PREPARING'::character varying, 'READY_FOR_PICKUP'::character varying, 'COMPLETED'::character varying])::text[]))),
    CONSTRAINT orders_order_status_check CHECK (((order_status)::text = ANY ((ARRAY['PENDING'::character varying, 'ACCEPTED'::character varying, 'REJECTED'::character varying, 'COMPLETED'::character varying])::text[]))),
    CONSTRAINT orders_payment_status_check CHECK (((payment_status)::text = ANY ((ARRAY['PENDING'::character varying, 'SUCCESS'::character varying, 'FAILED'::character varying])::text[])))
);


ALTER TABLE public.orders OWNER TO postgres;

--
-- Name: orders_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.orders_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.orders_id_seq OWNER TO postgres;

--
-- Name: orders_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.orders_id_seq OWNED BY public.orders.id;


--
-- Name: shops; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.shops (
    id bigint NOT NULL,
    address character varying(255),
    availability character varying(255) NOT NULL,
    created_at timestamp(6) without time zone,
    description text,
    name character varying(255) NOT NULL,
    phone character varying(255),
    updated_at timestamp(6) without time zone,
    shop_owner_id bigint NOT NULL,
    image_url character varying(255),
    CONSTRAINT shops_availability_check CHECK (((availability)::text = ANY ((ARRAY['OPEN'::character varying, 'CLOSED'::character varying])::text[])))
);


ALTER TABLE public.shops OWNER TO postgres;

--
-- Name: shops_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.shops_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.shops_id_seq OWNER TO postgres;

--
-- Name: shops_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.shops_id_seq OWNED BY public.shops.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    id bigint NOT NULL,
    address character varying(255),
    created_at timestamp(6) without time zone,
    email character varying(255) NOT NULL,
    name character varying(255) NOT NULL,
    password character varying(255) NOT NULL,
    phone character varying(255),
    role character varying(255) NOT NULL,
    updated_at timestamp(6) without time zone,
    CONSTRAINT users_role_check CHECK (((role)::text = ANY ((ARRAY['ADMIN'::character varying, 'SHOP_OWNER'::character varying, 'CUSTOMER'::character varying])::text[])))
);


ALTER TABLE public.users OWNER TO postgres;

--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.users_id_seq OWNER TO postgres;

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: cart_items id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cart_items ALTER COLUMN id SET DEFAULT nextval('public.cart_items_id_seq'::regclass);


--
-- Name: carts id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.carts ALTER COLUMN id SET DEFAULT nextval('public.carts_id_seq'::regclass);


--
-- Name: foods id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.foods ALTER COLUMN id SET DEFAULT nextval('public.foods_id_seq'::regclass);


--
-- Name: order_items id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_items ALTER COLUMN id SET DEFAULT nextval('public.order_items_id_seq'::regclass);


--
-- Name: orders id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders ALTER COLUMN id SET DEFAULT nextval('public.orders_id_seq'::regclass);


--
-- Name: shops id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.shops ALTER COLUMN id SET DEFAULT nextval('public.shops_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Data for Name: cart_items; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.cart_items (id, created_at, price, quantity, updated_at, cart_id, food_id) FROM stdin;
26	2026-09-09 14:40:21.200864	30.00	1	\N	1	2
\.


--
-- Data for Name: carts; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.carts (id, created_at, updated_at, customer_id) FROM stdin;
1	2026-09-08 23:09:17.788706	2026-09-08 23:09:17.788706	3
\.


--
-- Data for Name: foods; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.foods (id, availability, category, created_at, description, image_url, name, price, updated_at, shop_id, prep_time_minutes) FROM stdin;
2	t	BREAKFAST	2026-09-08 23:44:48.630618	Two steamed rice-and-lentil cakes with sambar and coconut chutney	/images/foods/idli.png	Idli	30.00	2026-09-08 23:44:48.630618	1	10
3	t	BREAKFAST	2026-09-08 23:44:48.661448	Two crispy golden urad-dal fritters with sambar and chutney	/images/foods/medu-vada.png	Medu Vada	35.00	2026-09-08 23:44:48.661448	1	10
4	t	BREAKFAST	2026-09-08 23:44:48.663476	Thin crisp rice-and-lentil crepe served with sambar and chutney	/images/foods/plain-dosa.png	Plain Dosa	50.00	2026-09-08 23:44:48.663476	1	10
5	t	BREAKFAST	2026-09-08 23:44:48.665479	Crisp dosa wrapped around spiced potato masala	/images/foods/masala-dosa.png	Masala Dosa	70.00	2026-09-08 23:44:48.665479	1	15
6	t	BREAKFAST	2026-09-08 23:44:48.667481	Extra-long dosa roasted in ghee until deep golden	/images/foods/ghee-roast-dosa.png	Ghee Roast Dosa	90.00	2026-09-08 23:44:48.667481	1	15
7	t	BREAKFAST	2026-09-08 23:44:48.67048	Lacy semolina dosa with onion, chilli and curry leaves	/images/foods/rava-dosa.png	Rava Dosa	80.00	2026-09-08 23:44:48.67048	1	15
8	t	BREAKFAST	2026-09-08 23:44:48.672481	Creamy rice-and-moong-dal pongal tempered with pepper, cumin and cashew	/images/foods/ven-pongal.png	Ven Pongal	45.00	2026-09-08 23:44:48.672481	1	12
9	t	BREAKFAST	2026-09-08 23:44:48.674481	Two fluffy pooris with potato masala	/images/foods/poori-masala.png	Poori Masala	55.00	2026-09-08 23:44:48.674481	1	12
10	t	BREAKFAST	2026-09-08 23:44:48.676478	Soft string hoppers with vegetable kurma	/images/foods/idiyappam-with-kurma.png	Idiyappam with Kurma	60.00	2026-09-08 23:44:48.676478	1	12
11	t	LUNCH	2026-09-08 23:44:48.677478	Rice with sambar, rasam, kootu, poriyal, curd, pickle and appalam	/images/foods/south-indian-veg-meals.png	South Indian Veg Meals	120.00	2026-09-08 23:44:48.677478	1	15
12	t	LUNCH	2026-09-08 23:44:48.68046	Comforting rice folded with curd, tempered with mustard and curry leaf	/images/foods/curd-rice.png	Curd Rice	50.00	2026-09-08 23:44:48.68046	1	8
13	t	LUNCH	2026-09-08 23:44:48.682065	Tangy turmeric rice with peanuts and curry leaves	/images/foods/lemon-rice.png	Lemon Rice	55.00	2026-09-08 23:44:48.682065	1	10
14	t	LUNCH	2026-09-08 23:44:48.684071	Puliyodarai - spiced tamarind rice with roasted peanuts	/images/foods/tamarind-rice.png	Tamarind Rice	55.00	2026-09-08 23:44:48.684071	1	10
15	t	LUNCH	2026-09-08 23:44:48.686071	One-pot rice cooked with lentils and mixed vegetables	/images/foods/sambar-rice.png	Sambar Rice	70.00	2026-09-08 23:44:48.686071	1	15
16	t	DINNER	2026-09-08 23:44:48.688072	Two layered flaky parottas with spicy salna gravy	/images/foods/parotta-with-salna.png	Parotta with Salna	70.00	2026-09-08 23:44:48.688072	1	15
17	t	DINNER	2026-09-08 23:44:48.690071	Two parottas with rich mixed-vegetable kurma	/images/foods/veg-kurma-parotta.png	Veg Kurma Parotta	95.00	2026-09-08 23:44:48.690071	1	18
18	t	LUNCH	2026-09-08 23:44:48.69207	Fragrant seeraga samba rice with vegetables and whole spices	/images/foods/veg-biryani.png	Veg Biryani	130.00	2026-09-08 23:44:48.69207	1	20
19	t	LUNCH	2026-09-08 23:44:48.693071	Seeraga samba biryani with marinated chicken and a boiled egg	/images/foods/chicken-biryani.png	Chicken Biryani	180.00	2026-09-08 23:44:48.693071	1	25
20	t	LUNCH	2026-09-08 23:44:48.695071	Spiced biryani with two boiled eggs	/images/foods/egg-biryani.png	Egg Biryani	140.00	2026-09-08 23:44:48.695071	1	22
21	t	SNACKS	2026-09-08 23:44:48.696071	Crisp fried chicken tossed with curry leaves, garlic and red chilli	/images/foods/chicken-65.png	Chicken 65	150.00	2026-09-08 23:44:48.696071	1	18
22	t	SNACKS	2026-09-08 23:44:48.69807	Crisp cauliflower florets in a tangy chilli toss	/images/foods/gobi-65.png	Gobi 65	110.00	2026-09-08 23:44:48.69807	1	16
23	t	SNACKS	2026-09-08 23:44:48.699561	Three mini crisp samosas filled with spiced onion	/images/foods/onion-samosa.png	Onion Samosa	30.00	2026-09-08 23:44:48.699561	1	8
24	t	BEVERAGES	2026-09-08 23:44:48.701568	Strong South-Indian style spiced tea	/images/foods/masala-chai.png	Masala Chai	15.00	2026-09-08 23:44:48.701568	1	5
25	t	BEVERAGES	2026-09-08 23:44:48.70357	Traditional degree coffee, frothy and strong	/images/foods/filter-coffee.png	Filter Coffee	20.00	2026-09-08 23:44:48.70357	1	5
26	t	BEVERAGES	2026-09-08 23:44:48.706568	Neer moru with ginger, green chilli and curry leaf	/images/foods/spiced-buttermilk.png	Spiced Buttermilk	20.00	2026-09-08 23:44:48.706568	1	4
27	t	DESSERTS	2026-09-08 23:44:48.710567	Warm vermicelli-and-milk kheer with cashew and raisin	/images/foods/semiya-payasam.png	Semiya Payasam	40.00	2026-09-08 23:44:48.710567	1	8
1	t	LUNCH	2026-09-08 23:16:10.15102	Delicious	/images/foods/biriyani.png	Biriyani	200.00	2026-09-08 23:44:48.737758	1	15
28	t	BREAKFAST	2026-09-09 00:10:51.879858	Two steamed rice-and-lentil cakes with sambar and coconut chutney	/images/foods/idli.png	Idli	30.00	2026-09-09 00:10:51.879858	2	10
48	t	FAST_FOOD	2026-09-09 00:10:52.164577	Crisp salted potato fries	/images/foods/french-fries.png	French Fries	80.00	2026-09-09 00:10:52.164577	4	10
29	t	BREAKFAST	2026-09-09 00:10:51.884375	Two crisp golden urad-dal fritters with sambar and chutney	/images/foods/medu-vada.png	Medu Vada	35.00	2026-09-09 00:10:51.884375	2	10
30	t	BREAKFAST	2026-09-09 00:10:51.889698	Thin crisp rice-and-lentil crepe with sambar and chutney	/images/foods/plain-dosa.png	Plain Dosa	50.00	2026-09-09 00:10:51.890698	2	10
31	t	BREAKFAST	2026-09-09 00:10:51.893697	Crisp dosa wrapped around spiced potato masala	/images/foods/masala-dosa.png	Masala Dosa	70.00	2026-09-09 00:10:51.893697	2	15
32	t	BREAKFAST	2026-09-09 00:10:51.896819	Extra-long dosa roasted in ghee until deep golden	/images/foods/ghee-roast-dosa.png	Ghee Roast Dosa	90.00	2026-09-09 00:10:51.896819	2	15
33	t	BREAKFAST	2026-09-09 00:10:51.899818	Lacy semolina dosa with onion, chilli and curry leaves	/images/foods/rava-dosa.png	Rava Dosa	80.00	2026-09-09 00:10:51.899818	2	15
34	t	BREAKFAST	2026-09-09 00:10:51.903818	Rice-and-moong-dal pongal tempered with pepper, cumin and cashew	/images/foods/ven-pongal.png	Ven Pongal	45.00	2026-09-09 00:10:51.903818	2	12
35	t	BREAKFAST	2026-09-09 00:10:51.907822	Two fluffy pooris with potato masala	/images/foods/poori-masala.png	Poori Masala	55.00	2026-09-09 00:10:51.907822	2	12
36	t	BEVERAGES	2026-09-09 00:10:51.912294	Traditional degree coffee, frothy and strong	/images/foods/filter-coffee.png	Filter Coffee	20.00	2026-09-09 00:10:51.912294	2	5
37	t	LUNCH	2026-09-09 00:10:52.012513	Seeraga samba biryani with marinated chicken and a boiled egg	/images/foods/chicken-biryani.png	Chicken Biryani	180.00	2026-09-09 00:10:52.012513	3	25
38	t	LUNCH	2026-09-09 00:10:52.014676	Slow-cooked mutton dum biryani with fried onion and mint	/images/foods/mutton-biryani.png	Mutton Biryani	240.00	2026-09-09 00:10:52.014676	3	30
39	t	LUNCH	2026-09-09 00:10:52.016684	Fragrant seeraga samba rice with vegetables and whole spices	/images/foods/veg-biryani.png	Veg Biryani	130.00	2026-09-09 00:10:52.016684	3	20
40	t	LUNCH	2026-09-09 00:10:52.020684	Spiced biryani with two boiled eggs	/images/foods/egg-biryani.png	Egg Biryani	140.00	2026-09-09 00:10:52.020684	3	22
41	t	LUNCH	2026-09-09 00:10:52.023684	Biryani layered with cubes of spiced paneer	/images/foods/paneer-biryani.png	Paneer Biryani	170.00	2026-09-09 00:10:52.023684	3	22
42	t	SNACKS	2026-09-09 00:10:52.025685	Crisp fried chicken tossed with curry leaves, garlic and red chilli	/images/foods/chicken-65.png	Chicken 65	150.00	2026-09-09 00:10:52.025685	3	18
43	t	SNACKS	2026-09-09 00:10:52.027684	Crisp cauliflower florets in a tangy chilli toss	/images/foods/gobi-65.png	Gobi 65	110.00	2026-09-09 00:10:52.027684	3	16
44	t	DESSERTS	2026-09-09 00:10:52.029683	Rich ghee-roasted bread halwa topped with nuts	/images/foods/bread-halwa.png	Bread Halwa	60.00	2026-09-09 00:10:52.029683	3	10
45	t	SNACKS	2026-09-09 00:10:52.158578	Two crisp pastry triangles with a spiced potato-pea filling	/images/foods/samosa.png	Samosa	20.00	2026-09-09 00:10:52.158578	4	8
46	t	SNACKS	2026-09-09 00:10:52.160575	Flaky baked puff pastry with a spiced vegetable filling	/images/foods/puffs.png	Puffs	25.00	2026-09-09 00:10:52.160575	4	8
47	t	SNACKS	2026-09-09 00:10:52.162576	Grilled sandwich with vegetables and mint chutney	/images/foods/veg-sandwich.png	Veg Sandwich	50.00	2026-09-09 00:10:52.162576	4	7
49	t	SNACKS	2026-09-09 00:10:52.166582	Kathi roll with spiced vegetables and onion	/images/foods/veg-roll.png	Veg Roll	60.00	2026-09-09 00:10:52.166582	4	10
50	t	SNACKS	2026-09-09 00:10:52.167582	Kathi roll with spiced chicken and onion	/images/foods/chicken-roll.png	Chicken Roll	90.00	2026-09-09 00:10:52.167582	4	12
51	t	BEVERAGES	2026-09-09 00:10:52.168582	Hot milk tea	/images/foods/tea.png	Tea	12.00	2026-09-09 00:10:52.168582	4	5
52	t	BEVERAGES	2026-09-09 00:10:52.172584	Hot milk coffee	/images/foods/coffee.png	Coffee	15.00	2026-09-09 00:10:52.172584	4	5
53	t	DINNER	2026-09-09 00:10:52.267913	Paneer cubes in a rich tomato-butter gravy	/images/foods/paneer-butter-masala.png	Paneer Butter Masala	160.00	2026-09-09 00:10:52.267913	5	20
54	t	LUNCH	2026-09-09 00:10:52.27104	Wok-tossed rice with mixed vegetables and soy	/images/foods/veg-fried-rice.png	Veg Fried Rice	110.00	2026-09-09 00:10:52.27104	5	15
55	t	SNACKS	2026-09-09 00:10:52.272039	Fried cauliflower in a tangy Indo-Chinese sauce	/images/foods/gobi-manchurian.png	Gobi Manchurian	120.00	2026-09-09 00:10:52.272039	5	16
56	t	LUNCH	2026-09-09 00:10:52.274372	Fried rice tossed with cubes of paneer	/images/foods/paneer-fried-rice.png	Paneer Fried Rice	140.00	2026-09-09 00:10:52.274372	5	16
57	t	DINNER	2026-09-09 00:10:52.276389	Two soft whole-wheat chapatis	/images/foods/chapati.png	Chapati	25.00	2026-09-09 00:10:52.276389	5	8
58	t	DINNER	2026-09-09 00:10:52.277386	Two layered flaky parottas	/images/foods/parotta.png	Parotta	25.00	2026-09-09 00:10:52.277386	5	12
59	t	LUNCH	2026-09-09 00:10:52.278093	Rice, chapati, dal, two curries, curd, pickle and papad	/images/foods/veg-meals.png	Veg Meals	120.00	2026-09-09 00:10:52.278093	5	15
60	t	DINNER	2026-09-09 00:10:52.279142	Yellow dal tempered with cumin, garlic and ghee	/images/foods/dal-tadka.png	Dal Tadka	90.00	2026-09-09 00:10:52.279142	5	15
61	t	LUNCH	2026-09-09 00:10:52.279982	Basmati rice tempered with cumin	/images/foods/jeera-rice.png	Jeera Rice	80.00	2026-09-09 00:10:52.279982	5	12
\.


--
-- Data for Name: order_items; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.order_items (id, created_at, food_name, item_status, price, quantity, food_id, order_id, shop_id) FROM stdin;
1	2026-09-08 23:16:45.014183	Biriyani	ACCEPTED	200.00	1	1	1	1
2	2026-09-08 23:46:17.380913	Idli	PENDING	30.00	2	2	2	1
3	2026-09-08 23:46:38.96193	Filter Coffee	PENDING	20.00	1	25	3	1
4	2026-09-08 23:46:38.962937	Chicken Biryani	PENDING	180.00	1	19	3	1
5	2026-09-08 23:51:43.910045	Masala Dosa	PENDING	70.00	1	5	4	1
6	2026-09-08 23:59:29.292928	Semiya Payasam	PENDING	40.00	1	27	5	1
7	2026-09-09 00:14:28.12489	Chicken Biryani	PENDING	180.00	1	37	6	3
8	2026-09-09 00:14:28.128889	Mutton Biryani	PENDING	240.00	1	38	6	3
10	2026-09-09 12:10:02.924831	Idli	PENDING	30.00	1	2	7	1
12	2026-09-09 12:45:24.51773	Chicken Biryani	PENDING	180.00	1	37	8	3
13	2026-09-09 12:45:51.658282	Chicken Biryani	PENDING	180.00	1	37	9	3
14	2026-09-09 12:45:51.659283	Gobi 65	PENDING	110.00	2	43	9	3
9	2026-09-09 12:10:02.918829	Egg Biryani	ACCEPTED	140.00	1	20	7	1
11	2026-09-09 12:10:02.92683	Medu Vada	ACCEPTED	35.00	1	3	7	1
15	2026-09-09 13:44:40.992271	Idli	PENDING	30.00	1	2	10	1
16	2026-09-09 14:25:14.119093	Filter Coffee	PENDING	20.00	2	36	11	2
17	2026-09-09 14:25:14.121769	Masala Dosa	PENDING	70.00	1	31	11	2
18	2026-09-09 14:34:48.198606	Filter Coffee	PENDING	20.00	1	36	12	2
19	2026-09-09 14:34:48.20262	Idli	PENDING	30.00	1	28	12	2
20	2026-09-09 14:36:43.924715	Idli	PENDING	30.00	1	2	13	1
21	2026-09-09 14:39:40.303887	Idli	PENDING	30.00	1	2	14	1
\.


--
-- Data for Name: orders; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.orders (id, created_at, order_status, payment_status, total_amount, updated_at, customer_id, completed_at, estimated_prep_minutes, fulfillment_status, placed_at, preparing_at, ready_at) FROM stdin;
1	2026-09-08 23:16:45.002643	ACCEPTED	SUCCESS	200.00	2026-09-08 23:45:54.314588	3	\N	15	ORDER_PLACED	2026-09-08 23:16:45.002643	\N	\N
2	2026-09-08 23:46:17.377911	PENDING	SUCCESS	60.00	2026-09-08 23:46:17.377911	3	\N	10	ORDER_PLACED	2026-09-08 23:46:17.377911	\N	\N
3	2026-09-08 23:46:38.959476	COMPLETED	SUCCESS	200.00	2026-09-08 23:46:40.503983	3	2026-09-08 23:46:40.501986	25	COMPLETED	2026-09-08 23:46:38.959477	2026-09-08 23:46:39.209331	2026-09-08 23:46:40.370348
4	2026-09-08 23:51:43.907028	PENDING	SUCCESS	70.00	2026-09-08 23:51:44.108698	3	\N	15	PREPARING	2026-09-08 23:51:43.90505	2026-09-08 23:51:44.105679	\N
5	2026-09-08 23:59:29.289939	PENDING	SUCCESS	40.00	2026-09-08 23:59:29.289939	3	\N	8	ORDER_PLACED	2026-09-08 23:59:29.28994	\N	\N
6	2026-09-09 00:14:28.118615	PENDING	SUCCESS	420.00	2026-09-09 00:14:29.460585	3	\N	30	PREPARING	2026-09-09 00:14:28.117618	2026-09-09 00:14:29.457588	\N
8	2026-09-09 12:45:24.515695	PENDING	SUCCESS	180.00	2026-09-09 12:45:24.644314	3	\N	25	PREPARING	2026-09-09 12:45:24.515695	2026-09-09 12:45:24.638268	\N
9	2026-09-09 12:45:51.656284	COMPLETED	SUCCESS	400.00	2026-09-09 12:45:52.577409	3	2026-09-09 12:45:52.576406	25	COMPLETED	2026-09-09 12:45:51.656284	2026-09-09 12:45:52.360766	2026-09-09 12:45:52.474031
7	2026-09-09 12:10:02.91383	PENDING	SUCCESS	205.00	2026-09-09 13:14:12.286857	3	\N	22	PREPARING	2026-09-09 12:10:02.913831	2026-09-09 13:14:12.270862	\N
10	2026-09-09 13:44:40.987269	PENDING	SUCCESS	30.00	2026-09-09 13:44:40.987269	3	\N	10	ORDER_PLACED	2026-09-09 13:44:40.986287	\N	\N
11	2026-09-09 14:25:14.116095	COMPLETED	SUCCESS	110.00	2026-09-09 14:26:48.471409	3	2026-09-09 14:26:48.4704	15	COMPLETED	2026-09-09 14:25:14.115083	2026-09-09 14:26:48.259168	2026-09-09 14:26:48.364263
12	2026-09-09 14:34:48.194592	PENDING	SUCCESS	50.00	2026-09-09 14:34:57.822456	3	\N	10	PREPARING	2026-09-09 14:34:48.194593	2026-09-09 14:34:57.821397	\N
14	2026-09-09 14:39:40.29927	COMPLETED	SUCCESS	30.00	2026-09-09 14:41:38.930295	3	2026-09-09 14:41:38.928285	10	COMPLETED	2026-09-09 14:39:40.298169	2026-09-09 14:41:33.712624	2026-09-09 14:41:37.57652
13	2026-09-09 14:36:43.921703	COMPLETED	SUCCESS	30.00	2026-09-09 14:41:58.78368	3	2026-09-09 14:41:58.782617	10	COMPLETED	2026-09-09 14:36:43.921704	2026-09-09 14:41:56.951788	2026-09-09 14:41:57.855797
\.


--
-- Data for Name: shops; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.shops (id, address, availability, created_at, description, name, phone, updated_at, shop_owner_id, image_url) FROM stdin;
2	Q-Free Campus, Block B, Level 1	OPEN	2026-09-09 00:10:51.869984	Classic tiffin counter - dosa, idli, pongal and filter coffee made fresh through the day.	Q-Free South Indian Kitchen	9876500002	2026-09-09 00:10:51.869984	4	/images/shops/q-free-south-indian-kitchen.svg
3	Q-Free Campus, Food Court, Stall 3	OPEN	2026-09-09 00:10:52.006513	Dum biryani specialists - chicken, mutton, egg, paneer and veg, with fried starters.	Q-Free Biryani House	9876500003	2026-09-09 00:10:52.006513	5	/images/shops/q-free-biryani-house.svg
4	Q-Free Campus, Near Library Entrance	OPEN	2026-09-09 00:10:52.144952	Quick bites between classes - samosa, puffs, rolls, sandwiches, fries, tea and coffee.	Q-Free Express Snacks	9876500004	2026-09-09 00:10:52.144952	6	/images/shops/q-free-express-snacks.svg
5	Q-Free Campus, Block C, Ground Floor	OPEN	2026-09-09 00:10:52.263905	Pure-veg North Indian and Indo-Chinese - curries, fried rice, breads and full meals.	Q-Free Veg Corner	9876500005	2026-09-09 00:10:52.263905	7	/images/shops/q-free-veg-corner.svg
1	Q-Free Campus, Block A, Ground Floor	CLOSED	2026-09-08 23:14:00.736147	The main campus cafe - tiffin, meals, biryani, snacks and beverages under one roof.	Q-Free Central Cafe	9876500001	2026-09-09 14:41:46.456007	2	/images/shops/q-free-central-cafe.svg
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (id, address, created_at, email, name, password, phone, role, updated_at) FROM stdin;
1	Food Hub HQ	2026-09-08 22:56:02.643178	admin@foodhub.com	Admin	$2a$10$Bo4RPLSoBXQt8Z7khWceBen.vglr5T6laV9Ek8IILfY7tdtXY96Bm	9999999999	ADMIN	2026-09-08 22:56:02.643178
2	123 Main Street	2026-09-08 22:56:02.735208	owner@foodhub.com	Shop Owner 1	$2a$10$4hS/JD1mJXQhPa26F3S7Ie4BAlvEbJW78hrBVJ4RwP4h0jKHwxz9q	8888888888	SHOP_OWNER	2026-09-08 22:56:02.735208
3	456 Oak Avenue	2026-09-08 22:56:02.807294	customer@foodhub.com	Test Customer	$2a$10$rC.EQj/F1cCpU08L96i/zOXFslPNKJ83BCxeWo6nGMdiF1.W4guaG	7777777777	CUSTOMER	2026-09-08 22:56:02.807294
4	Q-Free Campus	2026-09-09 00:10:51.859513	southindian@qfree.com	S. Ramesh	$2a$10$40JsrA/igh6FvxeG9ImiaeapbbiWjiNObyxsNhGx5qTASIMBmf1sm	9000000000	SHOP_OWNER	2026-09-09 00:10:51.859513
5	Q-Free Campus	2026-09-09 00:10:51.999483	biryani@qfree.com	K. Imran	$2a$10$Ji9xy3lSRcAmzGtjWJOGmeAJ0yL9JScyQKznX9stlMDELFv3CVQMq	9000000000	SHOP_OWNER	2026-09-09 00:10:51.999483
6	Q-Free Campus	2026-09-09 00:10:52.139897	snacks@qfree.com	M. Latha	$2a$10$rRWAitPhpzED5p053KmoVuCfThhrXVR/mFnT5dMEcTyAWWf6Dwg3u	9000000000	SHOP_OWNER	2026-09-09 00:10:52.139897
7	Q-Free Campus	2026-09-09 00:10:52.260026	veg@qfree.com	R. Priya	$2a$10$ZchGZW16rk4KXbvCdCukjue3gIxMTZ5/.nf.Pey8FQOhValXSDAea	9000000000	SHOP_OWNER	2026-09-09 00:10:52.260026
\.


--
-- Name: cart_items_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.cart_items_id_seq', 26, true);


--
-- Name: carts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.carts_id_seq', 1, true);


--
-- Name: foods_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.foods_id_seq', 62, true);


--
-- Name: order_items_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.order_items_id_seq', 21, true);


--
-- Name: orders_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.orders_id_seq', 14, true);


--
-- Name: shops_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.shops_id_seq', 5, true);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_id_seq', 8, true);


--
-- Name: cart_items cart_items_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cart_items
    ADD CONSTRAINT cart_items_pkey PRIMARY KEY (id);


--
-- Name: carts carts_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.carts
    ADD CONSTRAINT carts_pkey PRIMARY KEY (id);


--
-- Name: foods foods_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.foods
    ADD CONSTRAINT foods_pkey PRIMARY KEY (id);


--
-- Name: order_items order_items_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_items
    ADD CONSTRAINT order_items_pkey PRIMARY KEY (id);


--
-- Name: orders orders_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_pkey PRIMARY KEY (id);


--
-- Name: shops shops_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.shops
    ADD CONSTRAINT shops_pkey PRIMARY KEY (id);


--
-- Name: users uk_6dotkott2kjsp8vw4d0m25fb7; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT uk_6dotkott2kjsp8vw4d0m25fb7 UNIQUE (email);


--
-- Name: carts uk_88sv4i13lo80s74ox7rsb5a2c; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.carts
    ADD CONSTRAINT uk_88sv4i13lo80s74ox7rsb5a2c UNIQUE (customer_id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: order_items fk1huo7mby94sw84wam6xbfaex2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_items
    ADD CONSTRAINT fk1huo7mby94sw84wam6xbfaex2 FOREIGN KEY (food_id) REFERENCES public.foods(id);


--
-- Name: order_items fk1iyu6dct493xc5al3u9x3mds4; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_items
    ADD CONSTRAINT fk1iyu6dct493xc5al3u9x3mds4 FOREIGN KEY (shop_id) REFERENCES public.shops(id);


--
-- Name: carts fk99i1rh5nm7r3f1b3wdcuq5h57; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.carts
    ADD CONSTRAINT fk99i1rh5nm7r3f1b3wdcuq5h57 FOREIGN KEY (customer_id) REFERENCES public.users(id);


--
-- Name: shops fkaooonyunfgr3cltheo2onmfbb; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.shops
    ADD CONSTRAINT fkaooonyunfgr3cltheo2onmfbb FOREIGN KEY (shop_owner_id) REFERENCES public.users(id);


--
-- Name: foods fkb324gxsyxxl3lcjrhm31329he; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.foods
    ADD CONSTRAINT fkb324gxsyxxl3lcjrhm31329he FOREIGN KEY (shop_id) REFERENCES public.shops(id);


--
-- Name: order_items fkbioxgbv59vetrxe0ejfubep1w; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_items
    ADD CONSTRAINT fkbioxgbv59vetrxe0ejfubep1w FOREIGN KEY (order_id) REFERENCES public.orders(id);


--
-- Name: cart_items fkfgj1vb0wkn2gf7iowbxsgon5h; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cart_items
    ADD CONSTRAINT fkfgj1vb0wkn2gf7iowbxsgon5h FOREIGN KEY (food_id) REFERENCES public.foods(id);


--
-- Name: cart_items fkpcttvuq4mxppo8sxggjtn5i2c; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cart_items
    ADD CONSTRAINT fkpcttvuq4mxppo8sxggjtn5i2c FOREIGN KEY (cart_id) REFERENCES public.carts(id);


--
-- Name: orders fksjfs85qf6vmcurlx43cnc16gy; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT fksjfs85qf6vmcurlx43cnc16gy FOREIGN KEY (customer_id) REFERENCES public.users(id);


--
-- PostgreSQL database dump complete
--

\unrestrict YAHaBs9OpdB4xsBGJCzJH3sbaa2gpoWBW49jFazXaeJWITFmaxfVyWB7IjiJh1z

