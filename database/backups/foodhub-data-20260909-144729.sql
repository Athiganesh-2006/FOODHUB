--
-- PostgreSQL database dump
--

\restrict qZvozywhvmeV9muKf2clPAX0jjNGxWsWQev9C2h27cUHDTSy0jdu24mnCKVL9Hr

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

--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.users (id, address, created_at, email, name, password, phone, role, updated_at) VALUES (1, 'Food Hub HQ', '2026-09-08 22:56:02.643178', 'admin@foodhub.com', 'Admin', '$2a$10$Bo4RPLSoBXQt8Z7khWceBen.vglr5T6laV9Ek8IILfY7tdtXY96Bm', '9999999999', 'ADMIN', '2026-09-08 22:56:02.643178');
INSERT INTO public.users (id, address, created_at, email, name, password, phone, role, updated_at) VALUES (2, '123 Main Street', '2026-09-08 22:56:02.735208', 'owner@foodhub.com', 'Shop Owner 1', '$2a$10$4hS/JD1mJXQhPa26F3S7Ie4BAlvEbJW78hrBVJ4RwP4h0jKHwxz9q', '8888888888', 'SHOP_OWNER', '2026-09-08 22:56:02.735208');
INSERT INTO public.users (id, address, created_at, email, name, password, phone, role, updated_at) VALUES (3, '456 Oak Avenue', '2026-09-08 22:56:02.807294', 'customer@foodhub.com', 'Test Customer', '$2a$10$rC.EQj/F1cCpU08L96i/zOXFslPNKJ83BCxeWo6nGMdiF1.W4guaG', '7777777777', 'CUSTOMER', '2026-09-08 22:56:02.807294');
INSERT INTO public.users (id, address, created_at, email, name, password, phone, role, updated_at) VALUES (4, 'Q-Free Campus', '2026-09-09 00:10:51.859513', 'southindian@qfree.com', 'S. Ramesh', '$2a$10$40JsrA/igh6FvxeG9ImiaeapbbiWjiNObyxsNhGx5qTASIMBmf1sm', '9000000000', 'SHOP_OWNER', '2026-09-09 00:10:51.859513');
INSERT INTO public.users (id, address, created_at, email, name, password, phone, role, updated_at) VALUES (5, 'Q-Free Campus', '2026-09-09 00:10:51.999483', 'biryani@qfree.com', 'K. Imran', '$2a$10$Ji9xy3lSRcAmzGtjWJOGmeAJ0yL9JScyQKznX9stlMDELFv3CVQMq', '9000000000', 'SHOP_OWNER', '2026-09-09 00:10:51.999483');
INSERT INTO public.users (id, address, created_at, email, name, password, phone, role, updated_at) VALUES (6, 'Q-Free Campus', '2026-09-09 00:10:52.139897', 'snacks@qfree.com', 'M. Latha', '$2a$10$rRWAitPhpzED5p053KmoVuCfThhrXVR/mFnT5dMEcTyAWWf6Dwg3u', '9000000000', 'SHOP_OWNER', '2026-09-09 00:10:52.139897');
INSERT INTO public.users (id, address, created_at, email, name, password, phone, role, updated_at) VALUES (7, 'Q-Free Campus', '2026-09-09 00:10:52.260026', 'veg@qfree.com', 'R. Priya', '$2a$10$ZchGZW16rk4KXbvCdCukjue3gIxMTZ5/.nf.Pey8FQOhValXSDAea', '9000000000', 'SHOP_OWNER', '2026-09-09 00:10:52.260026');


--
-- Data for Name: carts; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.carts (id, created_at, updated_at, customer_id) VALUES (1, '2026-09-08 23:09:17.788706', '2026-09-08 23:09:17.788706', 3);


--
-- Data for Name: shops; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.shops (id, address, availability, created_at, description, name, phone, updated_at, shop_owner_id, image_url) VALUES (2, 'Q-Free Campus, Block B, Level 1', 'OPEN', '2026-09-09 00:10:51.869984', 'Classic tiffin counter - dosa, idli, pongal and filter coffee made fresh through the day.', 'Q-Free South Indian Kitchen', '9876500002', '2026-09-09 00:10:51.869984', 4, '/images/shops/q-free-south-indian-kitchen.svg');
INSERT INTO public.shops (id, address, availability, created_at, description, name, phone, updated_at, shop_owner_id, image_url) VALUES (3, 'Q-Free Campus, Food Court, Stall 3', 'OPEN', '2026-09-09 00:10:52.006513', 'Dum biryani specialists - chicken, mutton, egg, paneer and veg, with fried starters.', 'Q-Free Biryani House', '9876500003', '2026-09-09 00:10:52.006513', 5, '/images/shops/q-free-biryani-house.svg');
INSERT INTO public.shops (id, address, availability, created_at, description, name, phone, updated_at, shop_owner_id, image_url) VALUES (4, 'Q-Free Campus, Near Library Entrance', 'OPEN', '2026-09-09 00:10:52.144952', 'Quick bites between classes - samosa, puffs, rolls, sandwiches, fries, tea and coffee.', 'Q-Free Express Snacks', '9876500004', '2026-09-09 00:10:52.144952', 6, '/images/shops/q-free-express-snacks.svg');
INSERT INTO public.shops (id, address, availability, created_at, description, name, phone, updated_at, shop_owner_id, image_url) VALUES (5, 'Q-Free Campus, Block C, Ground Floor', 'OPEN', '2026-09-09 00:10:52.263905', 'Pure-veg North Indian and Indo-Chinese - curries, fried rice, breads and full meals.', 'Q-Free Veg Corner', '9876500005', '2026-09-09 00:10:52.263905', 7, '/images/shops/q-free-veg-corner.svg');
INSERT INTO public.shops (id, address, availability, created_at, description, name, phone, updated_at, shop_owner_id, image_url) VALUES (1, 'Q-Free Campus, Block A, Ground Floor', 'CLOSED', '2026-09-08 23:14:00.736147', 'The main campus cafe - tiffin, meals, biryani, snacks and beverages under one roof.', 'Q-Free Central Cafe', '9876500001', '2026-09-09 14:41:46.456007', 2, '/images/shops/q-free-central-cafe.svg');


--
-- Data for Name: foods; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.foods (id, availability, category, created_at, description, image_url, name, price, updated_at, shop_id, prep_time_minutes) VALUES (2, true, 'BREAKFAST', '2026-09-08 23:44:48.630618', 'Two steamed rice-and-lentil cakes with sambar and coconut chutney', '/images/foods/idli.png', 'Idli', 30.00, '2026-09-08 23:44:48.630618', 1, 10);
INSERT INTO public.foods (id, availability, category, created_at, description, image_url, name, price, updated_at, shop_id, prep_time_minutes) VALUES (3, true, 'BREAKFAST', '2026-09-08 23:44:48.661448', 'Two crispy golden urad-dal fritters with sambar and chutney', '/images/foods/medu-vada.png', 'Medu Vada', 35.00, '2026-09-08 23:44:48.661448', 1, 10);
INSERT INTO public.foods (id, availability, category, created_at, description, image_url, name, price, updated_at, shop_id, prep_time_minutes) VALUES (4, true, 'BREAKFAST', '2026-09-08 23:44:48.663476', 'Thin crisp rice-and-lentil crepe served with sambar and chutney', '/images/foods/plain-dosa.png', 'Plain Dosa', 50.00, '2026-09-08 23:44:48.663476', 1, 10);
INSERT INTO public.foods (id, availability, category, created_at, description, image_url, name, price, updated_at, shop_id, prep_time_minutes) VALUES (5, true, 'BREAKFAST', '2026-09-08 23:44:48.665479', 'Crisp dosa wrapped around spiced potato masala', '/images/foods/masala-dosa.png', 'Masala Dosa', 70.00, '2026-09-08 23:44:48.665479', 1, 15);
INSERT INTO public.foods (id, availability, category, created_at, description, image_url, name, price, updated_at, shop_id, prep_time_minutes) VALUES (6, true, 'BREAKFAST', '2026-09-08 23:44:48.667481', 'Extra-long dosa roasted in ghee until deep golden', '/images/foods/ghee-roast-dosa.png', 'Ghee Roast Dosa', 90.00, '2026-09-08 23:44:48.667481', 1, 15);
INSERT INTO public.foods (id, availability, category, created_at, description, image_url, name, price, updated_at, shop_id, prep_time_minutes) VALUES (7, true, 'BREAKFAST', '2026-09-08 23:44:48.67048', 'Lacy semolina dosa with onion, chilli and curry leaves', '/images/foods/rava-dosa.png', 'Rava Dosa', 80.00, '2026-09-08 23:44:48.67048', 1, 15);
INSERT INTO public.foods (id, availability, category, created_at, description, image_url, name, price, updated_at, shop_id, prep_time_minutes) VALUES (8, true, 'BREAKFAST', '2026-09-08 23:44:48.672481', 'Creamy rice-and-moong-dal pongal tempered with pepper, cumin and cashew', '/images/foods/ven-pongal.png', 'Ven Pongal', 45.00, '2026-09-08 23:44:48.672481', 1, 12);
INSERT INTO public.foods (id, availability, category, created_at, description, image_url, name, price, updated_at, shop_id, prep_time_minutes) VALUES (9, true, 'BREAKFAST', '2026-09-08 23:44:48.674481', 'Two fluffy pooris with potato masala', '/images/foods/poori-masala.png', 'Poori Masala', 55.00, '2026-09-08 23:44:48.674481', 1, 12);
INSERT INTO public.foods (id, availability, category, created_at, description, image_url, name, price, updated_at, shop_id, prep_time_minutes) VALUES (10, true, 'BREAKFAST', '2026-09-08 23:44:48.676478', 'Soft string hoppers with vegetable kurma', '/images/foods/idiyappam-with-kurma.png', 'Idiyappam with Kurma', 60.00, '2026-09-08 23:44:48.676478', 1, 12);
INSERT INTO public.foods (id, availability, category, created_at, description, image_url, name, price, updated_at, shop_id, prep_time_minutes) VALUES (11, true, 'LUNCH', '2026-09-08 23:44:48.677478', 'Rice with sambar, rasam, kootu, poriyal, curd, pickle and appalam', '/images/foods/south-indian-veg-meals.png', 'South Indian Veg Meals', 120.00, '2026-09-08 23:44:48.677478', 1, 15);
INSERT INTO public.foods (id, availability, category, created_at, description, image_url, name, price, updated_at, shop_id, prep_time_minutes) VALUES (12, true, 'LUNCH', '2026-09-08 23:44:48.68046', 'Comforting rice folded with curd, tempered with mustard and curry leaf', '/images/foods/curd-rice.png', 'Curd Rice', 50.00, '2026-09-08 23:44:48.68046', 1, 8);
INSERT INTO public.foods (id, availability, category, created_at, description, image_url, name, price, updated_at, shop_id, prep_time_minutes) VALUES (13, true, 'LUNCH', '2026-09-08 23:44:48.682065', 'Tangy turmeric rice with peanuts and curry leaves', '/images/foods/lemon-rice.png', 'Lemon Rice', 55.00, '2026-09-08 23:44:48.682065', 1, 10);
INSERT INTO public.foods (id, availability, category, created_at, description, image_url, name, price, updated_at, shop_id, prep_time_minutes) VALUES (14, true, 'LUNCH', '2026-09-08 23:44:48.684071', 'Puliyodarai - spiced tamarind rice with roasted peanuts', '/images/foods/tamarind-rice.png', 'Tamarind Rice', 55.00, '2026-09-08 23:44:48.684071', 1, 10);
INSERT INTO public.foods (id, availability, category, created_at, description, image_url, name, price, updated_at, shop_id, prep_time_minutes) VALUES (15, true, 'LUNCH', '2026-09-08 23:44:48.686071', 'One-pot rice cooked with lentils and mixed vegetables', '/images/foods/sambar-rice.png', 'Sambar Rice', 70.00, '2026-09-08 23:44:48.686071', 1, 15);
INSERT INTO public.foods (id, availability, category, created_at, description, image_url, name, price, updated_at, shop_id, prep_time_minutes) VALUES (16, true, 'DINNER', '2026-09-08 23:44:48.688072', 'Two layered flaky parottas with spicy salna gravy', '/images/foods/parotta-with-salna.png', 'Parotta with Salna', 70.00, '2026-09-08 23:44:48.688072', 1, 15);
INSERT INTO public.foods (id, availability, category, created_at, description, image_url, name, price, updated_at, shop_id, prep_time_minutes) VALUES (17, true, 'DINNER', '2026-09-08 23:44:48.690071', 'Two parottas with rich mixed-vegetable kurma', '/images/foods/veg-kurma-parotta.png', 'Veg Kurma Parotta', 95.00, '2026-09-08 23:44:48.690071', 1, 18);
INSERT INTO public.foods (id, availability, category, created_at, description, image_url, name, price, updated_at, shop_id, prep_time_minutes) VALUES (18, true, 'LUNCH', '2026-09-08 23:44:48.69207', 'Fragrant seeraga samba rice with vegetables and whole spices', '/images/foods/veg-biryani.png', 'Veg Biryani', 130.00, '2026-09-08 23:44:48.69207', 1, 20);
INSERT INTO public.foods (id, availability, category, created_at, description, image_url, name, price, updated_at, shop_id, prep_time_minutes) VALUES (19, true, 'LUNCH', '2026-09-08 23:44:48.693071', 'Seeraga samba biryani with marinated chicken and a boiled egg', '/images/foods/chicken-biryani.png', 'Chicken Biryani', 180.00, '2026-09-08 23:44:48.693071', 1, 25);
INSERT INTO public.foods (id, availability, category, created_at, description, image_url, name, price, updated_at, shop_id, prep_time_minutes) VALUES (20, true, 'LUNCH', '2026-09-08 23:44:48.695071', 'Spiced biryani with two boiled eggs', '/images/foods/egg-biryani.png', 'Egg Biryani', 140.00, '2026-09-08 23:44:48.695071', 1, 22);
INSERT INTO public.foods (id, availability, category, created_at, description, image_url, name, price, updated_at, shop_id, prep_time_minutes) VALUES (21, true, 'SNACKS', '2026-09-08 23:44:48.696071', 'Crisp fried chicken tossed with curry leaves, garlic and red chilli', '/images/foods/chicken-65.png', 'Chicken 65', 150.00, '2026-09-08 23:44:48.696071', 1, 18);
INSERT INTO public.foods (id, availability, category, created_at, description, image_url, name, price, updated_at, shop_id, prep_time_minutes) VALUES (22, true, 'SNACKS', '2026-09-08 23:44:48.69807', 'Crisp cauliflower florets in a tangy chilli toss', '/images/foods/gobi-65.png', 'Gobi 65', 110.00, '2026-09-08 23:44:48.69807', 1, 16);
INSERT INTO public.foods (id, availability, category, created_at, description, image_url, name, price, updated_at, shop_id, prep_time_minutes) VALUES (23, true, 'SNACKS', '2026-09-08 23:44:48.699561', 'Three mini crisp samosas filled with spiced onion', '/images/foods/onion-samosa.png', 'Onion Samosa', 30.00, '2026-09-08 23:44:48.699561', 1, 8);
INSERT INTO public.foods (id, availability, category, created_at, description, image_url, name, price, updated_at, shop_id, prep_time_minutes) VALUES (24, true, 'BEVERAGES', '2026-09-08 23:44:48.701568', 'Strong South-Indian style spiced tea', '/images/foods/masala-chai.png', 'Masala Chai', 15.00, '2026-09-08 23:44:48.701568', 1, 5);
INSERT INTO public.foods (id, availability, category, created_at, description, image_url, name, price, updated_at, shop_id, prep_time_minutes) VALUES (25, true, 'BEVERAGES', '2026-09-08 23:44:48.70357', 'Traditional degree coffee, frothy and strong', '/images/foods/filter-coffee.png', 'Filter Coffee', 20.00, '2026-09-08 23:44:48.70357', 1, 5);
INSERT INTO public.foods (id, availability, category, created_at, description, image_url, name, price, updated_at, shop_id, prep_time_minutes) VALUES (26, true, 'BEVERAGES', '2026-09-08 23:44:48.706568', 'Neer moru with ginger, green chilli and curry leaf', '/images/foods/spiced-buttermilk.png', 'Spiced Buttermilk', 20.00, '2026-09-08 23:44:48.706568', 1, 4);
INSERT INTO public.foods (id, availability, category, created_at, description, image_url, name, price, updated_at, shop_id, prep_time_minutes) VALUES (27, true, 'DESSERTS', '2026-09-08 23:44:48.710567', 'Warm vermicelli-and-milk kheer with cashew and raisin', '/images/foods/semiya-payasam.png', 'Semiya Payasam', 40.00, '2026-09-08 23:44:48.710567', 1, 8);
INSERT INTO public.foods (id, availability, category, created_at, description, image_url, name, price, updated_at, shop_id, prep_time_minutes) VALUES (1, true, 'LUNCH', '2026-09-08 23:16:10.15102', 'Delicious', '/images/foods/biriyani.png', 'Biriyani', 200.00, '2026-09-08 23:44:48.737758', 1, 15);
INSERT INTO public.foods (id, availability, category, created_at, description, image_url, name, price, updated_at, shop_id, prep_time_minutes) VALUES (28, true, 'BREAKFAST', '2026-09-09 00:10:51.879858', 'Two steamed rice-and-lentil cakes with sambar and coconut chutney', '/images/foods/idli.png', 'Idli', 30.00, '2026-09-09 00:10:51.879858', 2, 10);
INSERT INTO public.foods (id, availability, category, created_at, description, image_url, name, price, updated_at, shop_id, prep_time_minutes) VALUES (48, true, 'FAST_FOOD', '2026-09-09 00:10:52.164577', 'Crisp salted potato fries', '/images/foods/french-fries.png', 'French Fries', 80.00, '2026-09-09 00:10:52.164577', 4, 10);
INSERT INTO public.foods (id, availability, category, created_at, description, image_url, name, price, updated_at, shop_id, prep_time_minutes) VALUES (29, true, 'BREAKFAST', '2026-09-09 00:10:51.884375', 'Two crisp golden urad-dal fritters with sambar and chutney', '/images/foods/medu-vada.png', 'Medu Vada', 35.00, '2026-09-09 00:10:51.884375', 2, 10);
INSERT INTO public.foods (id, availability, category, created_at, description, image_url, name, price, updated_at, shop_id, prep_time_minutes) VALUES (30, true, 'BREAKFAST', '2026-09-09 00:10:51.889698', 'Thin crisp rice-and-lentil crepe with sambar and chutney', '/images/foods/plain-dosa.png', 'Plain Dosa', 50.00, '2026-09-09 00:10:51.890698', 2, 10);
INSERT INTO public.foods (id, availability, category, created_at, description, image_url, name, price, updated_at, shop_id, prep_time_minutes) VALUES (31, true, 'BREAKFAST', '2026-09-09 00:10:51.893697', 'Crisp dosa wrapped around spiced potato masala', '/images/foods/masala-dosa.png', 'Masala Dosa', 70.00, '2026-09-09 00:10:51.893697', 2, 15);
INSERT INTO public.foods (id, availability, category, created_at, description, image_url, name, price, updated_at, shop_id, prep_time_minutes) VALUES (32, true, 'BREAKFAST', '2026-09-09 00:10:51.896819', 'Extra-long dosa roasted in ghee until deep golden', '/images/foods/ghee-roast-dosa.png', 'Ghee Roast Dosa', 90.00, '2026-09-09 00:10:51.896819', 2, 15);
INSERT INTO public.foods (id, availability, category, created_at, description, image_url, name, price, updated_at, shop_id, prep_time_minutes) VALUES (33, true, 'BREAKFAST', '2026-09-09 00:10:51.899818', 'Lacy semolina dosa with onion, chilli and curry leaves', '/images/foods/rava-dosa.png', 'Rava Dosa', 80.00, '2026-09-09 00:10:51.899818', 2, 15);
INSERT INTO public.foods (id, availability, category, created_at, description, image_url, name, price, updated_at, shop_id, prep_time_minutes) VALUES (34, true, 'BREAKFAST', '2026-09-09 00:10:51.903818', 'Rice-and-moong-dal pongal tempered with pepper, cumin and cashew', '/images/foods/ven-pongal.png', 'Ven Pongal', 45.00, '2026-09-09 00:10:51.903818', 2, 12);
INSERT INTO public.foods (id, availability, category, created_at, description, image_url, name, price, updated_at, shop_id, prep_time_minutes) VALUES (35, true, 'BREAKFAST', '2026-09-09 00:10:51.907822', 'Two fluffy pooris with potato masala', '/images/foods/poori-masala.png', 'Poori Masala', 55.00, '2026-09-09 00:10:51.907822', 2, 12);
INSERT INTO public.foods (id, availability, category, created_at, description, image_url, name, price, updated_at, shop_id, prep_time_minutes) VALUES (36, true, 'BEVERAGES', '2026-09-09 00:10:51.912294', 'Traditional degree coffee, frothy and strong', '/images/foods/filter-coffee.png', 'Filter Coffee', 20.00, '2026-09-09 00:10:51.912294', 2, 5);
INSERT INTO public.foods (id, availability, category, created_at, description, image_url, name, price, updated_at, shop_id, prep_time_minutes) VALUES (37, true, 'LUNCH', '2026-09-09 00:10:52.012513', 'Seeraga samba biryani with marinated chicken and a boiled egg', '/images/foods/chicken-biryani.png', 'Chicken Biryani', 180.00, '2026-09-09 00:10:52.012513', 3, 25);
INSERT INTO public.foods (id, availability, category, created_at, description, image_url, name, price, updated_at, shop_id, prep_time_minutes) VALUES (38, true, 'LUNCH', '2026-09-09 00:10:52.014676', 'Slow-cooked mutton dum biryani with fried onion and mint', '/images/foods/mutton-biryani.png', 'Mutton Biryani', 240.00, '2026-09-09 00:10:52.014676', 3, 30);
INSERT INTO public.foods (id, availability, category, created_at, description, image_url, name, price, updated_at, shop_id, prep_time_minutes) VALUES (39, true, 'LUNCH', '2026-09-09 00:10:52.016684', 'Fragrant seeraga samba rice with vegetables and whole spices', '/images/foods/veg-biryani.png', 'Veg Biryani', 130.00, '2026-09-09 00:10:52.016684', 3, 20);
INSERT INTO public.foods (id, availability, category, created_at, description, image_url, name, price, updated_at, shop_id, prep_time_minutes) VALUES (40, true, 'LUNCH', '2026-09-09 00:10:52.020684', 'Spiced biryani with two boiled eggs', '/images/foods/egg-biryani.png', 'Egg Biryani', 140.00, '2026-09-09 00:10:52.020684', 3, 22);
INSERT INTO public.foods (id, availability, category, created_at, description, image_url, name, price, updated_at, shop_id, prep_time_minutes) VALUES (41, true, 'LUNCH', '2026-09-09 00:10:52.023684', 'Biryani layered with cubes of spiced paneer', '/images/foods/paneer-biryani.png', 'Paneer Biryani', 170.00, '2026-09-09 00:10:52.023684', 3, 22);
INSERT INTO public.foods (id, availability, category, created_at, description, image_url, name, price, updated_at, shop_id, prep_time_minutes) VALUES (42, true, 'SNACKS', '2026-09-09 00:10:52.025685', 'Crisp fried chicken tossed with curry leaves, garlic and red chilli', '/images/foods/chicken-65.png', 'Chicken 65', 150.00, '2026-09-09 00:10:52.025685', 3, 18);
INSERT INTO public.foods (id, availability, category, created_at, description, image_url, name, price, updated_at, shop_id, prep_time_minutes) VALUES (43, true, 'SNACKS', '2026-09-09 00:10:52.027684', 'Crisp cauliflower florets in a tangy chilli toss', '/images/foods/gobi-65.png', 'Gobi 65', 110.00, '2026-09-09 00:10:52.027684', 3, 16);
INSERT INTO public.foods (id, availability, category, created_at, description, image_url, name, price, updated_at, shop_id, prep_time_minutes) VALUES (44, true, 'DESSERTS', '2026-09-09 00:10:52.029683', 'Rich ghee-roasted bread halwa topped with nuts', '/images/foods/bread-halwa.png', 'Bread Halwa', 60.00, '2026-09-09 00:10:52.029683', 3, 10);
INSERT INTO public.foods (id, availability, category, created_at, description, image_url, name, price, updated_at, shop_id, prep_time_minutes) VALUES (45, true, 'SNACKS', '2026-09-09 00:10:52.158578', 'Two crisp pastry triangles with a spiced potato-pea filling', '/images/foods/samosa.png', 'Samosa', 20.00, '2026-09-09 00:10:52.158578', 4, 8);
INSERT INTO public.foods (id, availability, category, created_at, description, image_url, name, price, updated_at, shop_id, prep_time_minutes) VALUES (46, true, 'SNACKS', '2026-09-09 00:10:52.160575', 'Flaky baked puff pastry with a spiced vegetable filling', '/images/foods/puffs.png', 'Puffs', 25.00, '2026-09-09 00:10:52.160575', 4, 8);
INSERT INTO public.foods (id, availability, category, created_at, description, image_url, name, price, updated_at, shop_id, prep_time_minutes) VALUES (47, true, 'SNACKS', '2026-09-09 00:10:52.162576', 'Grilled sandwich with vegetables and mint chutney', '/images/foods/veg-sandwich.png', 'Veg Sandwich', 50.00, '2026-09-09 00:10:52.162576', 4, 7);
INSERT INTO public.foods (id, availability, category, created_at, description, image_url, name, price, updated_at, shop_id, prep_time_minutes) VALUES (49, true, 'SNACKS', '2026-09-09 00:10:52.166582', 'Kathi roll with spiced vegetables and onion', '/images/foods/veg-roll.png', 'Veg Roll', 60.00, '2026-09-09 00:10:52.166582', 4, 10);
INSERT INTO public.foods (id, availability, category, created_at, description, image_url, name, price, updated_at, shop_id, prep_time_minutes) VALUES (50, true, 'SNACKS', '2026-09-09 00:10:52.167582', 'Kathi roll with spiced chicken and onion', '/images/foods/chicken-roll.png', 'Chicken Roll', 90.00, '2026-09-09 00:10:52.167582', 4, 12);
INSERT INTO public.foods (id, availability, category, created_at, description, image_url, name, price, updated_at, shop_id, prep_time_minutes) VALUES (51, true, 'BEVERAGES', '2026-09-09 00:10:52.168582', 'Hot milk tea', '/images/foods/tea.png', 'Tea', 12.00, '2026-09-09 00:10:52.168582', 4, 5);
INSERT INTO public.foods (id, availability, category, created_at, description, image_url, name, price, updated_at, shop_id, prep_time_minutes) VALUES (52, true, 'BEVERAGES', '2026-09-09 00:10:52.172584', 'Hot milk coffee', '/images/foods/coffee.png', 'Coffee', 15.00, '2026-09-09 00:10:52.172584', 4, 5);
INSERT INTO public.foods (id, availability, category, created_at, description, image_url, name, price, updated_at, shop_id, prep_time_minutes) VALUES (53, true, 'DINNER', '2026-09-09 00:10:52.267913', 'Paneer cubes in a rich tomato-butter gravy', '/images/foods/paneer-butter-masala.png', 'Paneer Butter Masala', 160.00, '2026-09-09 00:10:52.267913', 5, 20);
INSERT INTO public.foods (id, availability, category, created_at, description, image_url, name, price, updated_at, shop_id, prep_time_minutes) VALUES (54, true, 'LUNCH', '2026-09-09 00:10:52.27104', 'Wok-tossed rice with mixed vegetables and soy', '/images/foods/veg-fried-rice.png', 'Veg Fried Rice', 110.00, '2026-09-09 00:10:52.27104', 5, 15);
INSERT INTO public.foods (id, availability, category, created_at, description, image_url, name, price, updated_at, shop_id, prep_time_minutes) VALUES (55, true, 'SNACKS', '2026-09-09 00:10:52.272039', 'Fried cauliflower in a tangy Indo-Chinese sauce', '/images/foods/gobi-manchurian.png', 'Gobi Manchurian', 120.00, '2026-09-09 00:10:52.272039', 5, 16);
INSERT INTO public.foods (id, availability, category, created_at, description, image_url, name, price, updated_at, shop_id, prep_time_minutes) VALUES (56, true, 'LUNCH', '2026-09-09 00:10:52.274372', 'Fried rice tossed with cubes of paneer', '/images/foods/paneer-fried-rice.png', 'Paneer Fried Rice', 140.00, '2026-09-09 00:10:52.274372', 5, 16);
INSERT INTO public.foods (id, availability, category, created_at, description, image_url, name, price, updated_at, shop_id, prep_time_minutes) VALUES (57, true, 'DINNER', '2026-09-09 00:10:52.276389', 'Two soft whole-wheat chapatis', '/images/foods/chapati.png', 'Chapati', 25.00, '2026-09-09 00:10:52.276389', 5, 8);
INSERT INTO public.foods (id, availability, category, created_at, description, image_url, name, price, updated_at, shop_id, prep_time_minutes) VALUES (58, true, 'DINNER', '2026-09-09 00:10:52.277386', 'Two layered flaky parottas', '/images/foods/parotta.png', 'Parotta', 25.00, '2026-09-09 00:10:52.277386', 5, 12);
INSERT INTO public.foods (id, availability, category, created_at, description, image_url, name, price, updated_at, shop_id, prep_time_minutes) VALUES (59, true, 'LUNCH', '2026-09-09 00:10:52.278093', 'Rice, chapati, dal, two curries, curd, pickle and papad', '/images/foods/veg-meals.png', 'Veg Meals', 120.00, '2026-09-09 00:10:52.278093', 5, 15);
INSERT INTO public.foods (id, availability, category, created_at, description, image_url, name, price, updated_at, shop_id, prep_time_minutes) VALUES (60, true, 'DINNER', '2026-09-09 00:10:52.279142', 'Yellow dal tempered with cumin, garlic and ghee', '/images/foods/dal-tadka.png', 'Dal Tadka', 90.00, '2026-09-09 00:10:52.279142', 5, 15);
INSERT INTO public.foods (id, availability, category, created_at, description, image_url, name, price, updated_at, shop_id, prep_time_minutes) VALUES (61, true, 'LUNCH', '2026-09-09 00:10:52.279982', 'Basmati rice tempered with cumin', '/images/foods/jeera-rice.png', 'Jeera Rice', 80.00, '2026-09-09 00:10:52.279982', 5, 12);


--
-- Data for Name: cart_items; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.cart_items (id, created_at, price, quantity, updated_at, cart_id, food_id) VALUES (26, '2026-09-09 14:40:21.200864', 30.00, 1, NULL, 1, 2);


--
-- Data for Name: orders; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.orders (id, created_at, order_status, payment_status, total_amount, updated_at, customer_id, completed_at, estimated_prep_minutes, fulfillment_status, placed_at, preparing_at, ready_at) VALUES (1, '2026-09-08 23:16:45.002643', 'ACCEPTED', 'SUCCESS', 200.00, '2026-09-08 23:45:54.314588', 3, NULL, 15, 'ORDER_PLACED', '2026-09-08 23:16:45.002643', NULL, NULL);
INSERT INTO public.orders (id, created_at, order_status, payment_status, total_amount, updated_at, customer_id, completed_at, estimated_prep_minutes, fulfillment_status, placed_at, preparing_at, ready_at) VALUES (2, '2026-09-08 23:46:17.377911', 'PENDING', 'SUCCESS', 60.00, '2026-09-08 23:46:17.377911', 3, NULL, 10, 'ORDER_PLACED', '2026-09-08 23:46:17.377911', NULL, NULL);
INSERT INTO public.orders (id, created_at, order_status, payment_status, total_amount, updated_at, customer_id, completed_at, estimated_prep_minutes, fulfillment_status, placed_at, preparing_at, ready_at) VALUES (3, '2026-09-08 23:46:38.959476', 'COMPLETED', 'SUCCESS', 200.00, '2026-09-08 23:46:40.503983', 3, '2026-09-08 23:46:40.501986', 25, 'COMPLETED', '2026-09-08 23:46:38.959477', '2026-09-08 23:46:39.209331', '2026-09-08 23:46:40.370348');
INSERT INTO public.orders (id, created_at, order_status, payment_status, total_amount, updated_at, customer_id, completed_at, estimated_prep_minutes, fulfillment_status, placed_at, preparing_at, ready_at) VALUES (4, '2026-09-08 23:51:43.907028', 'PENDING', 'SUCCESS', 70.00, '2026-09-08 23:51:44.108698', 3, NULL, 15, 'PREPARING', '2026-09-08 23:51:43.90505', '2026-09-08 23:51:44.105679', NULL);
INSERT INTO public.orders (id, created_at, order_status, payment_status, total_amount, updated_at, customer_id, completed_at, estimated_prep_minutes, fulfillment_status, placed_at, preparing_at, ready_at) VALUES (5, '2026-09-08 23:59:29.289939', 'PENDING', 'SUCCESS', 40.00, '2026-09-08 23:59:29.289939', 3, NULL, 8, 'ORDER_PLACED', '2026-09-08 23:59:29.28994', NULL, NULL);
INSERT INTO public.orders (id, created_at, order_status, payment_status, total_amount, updated_at, customer_id, completed_at, estimated_prep_minutes, fulfillment_status, placed_at, preparing_at, ready_at) VALUES (6, '2026-09-09 00:14:28.118615', 'PENDING', 'SUCCESS', 420.00, '2026-09-09 00:14:29.460585', 3, NULL, 30, 'PREPARING', '2026-09-09 00:14:28.117618', '2026-09-09 00:14:29.457588', NULL);
INSERT INTO public.orders (id, created_at, order_status, payment_status, total_amount, updated_at, customer_id, completed_at, estimated_prep_minutes, fulfillment_status, placed_at, preparing_at, ready_at) VALUES (8, '2026-09-09 12:45:24.515695', 'PENDING', 'SUCCESS', 180.00, '2026-09-09 12:45:24.644314', 3, NULL, 25, 'PREPARING', '2026-09-09 12:45:24.515695', '2026-09-09 12:45:24.638268', NULL);
INSERT INTO public.orders (id, created_at, order_status, payment_status, total_amount, updated_at, customer_id, completed_at, estimated_prep_minutes, fulfillment_status, placed_at, preparing_at, ready_at) VALUES (9, '2026-09-09 12:45:51.656284', 'COMPLETED', 'SUCCESS', 400.00, '2026-09-09 12:45:52.577409', 3, '2026-09-09 12:45:52.576406', 25, 'COMPLETED', '2026-09-09 12:45:51.656284', '2026-09-09 12:45:52.360766', '2026-09-09 12:45:52.474031');
INSERT INTO public.orders (id, created_at, order_status, payment_status, total_amount, updated_at, customer_id, completed_at, estimated_prep_minutes, fulfillment_status, placed_at, preparing_at, ready_at) VALUES (7, '2026-09-09 12:10:02.91383', 'PENDING', 'SUCCESS', 205.00, '2026-09-09 13:14:12.286857', 3, NULL, 22, 'PREPARING', '2026-09-09 12:10:02.913831', '2026-09-09 13:14:12.270862', NULL);
INSERT INTO public.orders (id, created_at, order_status, payment_status, total_amount, updated_at, customer_id, completed_at, estimated_prep_minutes, fulfillment_status, placed_at, preparing_at, ready_at) VALUES (10, '2026-09-09 13:44:40.987269', 'PENDING', 'SUCCESS', 30.00, '2026-09-09 13:44:40.987269', 3, NULL, 10, 'ORDER_PLACED', '2026-09-09 13:44:40.986287', NULL, NULL);
INSERT INTO public.orders (id, created_at, order_status, payment_status, total_amount, updated_at, customer_id, completed_at, estimated_prep_minutes, fulfillment_status, placed_at, preparing_at, ready_at) VALUES (11, '2026-09-09 14:25:14.116095', 'COMPLETED', 'SUCCESS', 110.00, '2026-09-09 14:26:48.471409', 3, '2026-09-09 14:26:48.4704', 15, 'COMPLETED', '2026-09-09 14:25:14.115083', '2026-09-09 14:26:48.259168', '2026-09-09 14:26:48.364263');
INSERT INTO public.orders (id, created_at, order_status, payment_status, total_amount, updated_at, customer_id, completed_at, estimated_prep_minutes, fulfillment_status, placed_at, preparing_at, ready_at) VALUES (12, '2026-09-09 14:34:48.194592', 'PENDING', 'SUCCESS', 50.00, '2026-09-09 14:34:57.822456', 3, NULL, 10, 'PREPARING', '2026-09-09 14:34:48.194593', '2026-09-09 14:34:57.821397', NULL);
INSERT INTO public.orders (id, created_at, order_status, payment_status, total_amount, updated_at, customer_id, completed_at, estimated_prep_minutes, fulfillment_status, placed_at, preparing_at, ready_at) VALUES (14, '2026-09-09 14:39:40.29927', 'COMPLETED', 'SUCCESS', 30.00, '2026-09-09 14:41:38.930295', 3, '2026-09-09 14:41:38.928285', 10, 'COMPLETED', '2026-09-09 14:39:40.298169', '2026-09-09 14:41:33.712624', '2026-09-09 14:41:37.57652');
INSERT INTO public.orders (id, created_at, order_status, payment_status, total_amount, updated_at, customer_id, completed_at, estimated_prep_minutes, fulfillment_status, placed_at, preparing_at, ready_at) VALUES (13, '2026-09-09 14:36:43.921703', 'COMPLETED', 'SUCCESS', 30.00, '2026-09-09 14:41:58.78368', 3, '2026-09-09 14:41:58.782617', 10, 'COMPLETED', '2026-09-09 14:36:43.921704', '2026-09-09 14:41:56.951788', '2026-09-09 14:41:57.855797');


--
-- Data for Name: order_items; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.order_items (id, created_at, food_name, item_status, price, quantity, food_id, order_id, shop_id) VALUES (1, '2026-09-08 23:16:45.014183', 'Biriyani', 'ACCEPTED', 200.00, 1, 1, 1, 1);
INSERT INTO public.order_items (id, created_at, food_name, item_status, price, quantity, food_id, order_id, shop_id) VALUES (2, '2026-09-08 23:46:17.380913', 'Idli', 'PENDING', 30.00, 2, 2, 2, 1);
INSERT INTO public.order_items (id, created_at, food_name, item_status, price, quantity, food_id, order_id, shop_id) VALUES (3, '2026-09-08 23:46:38.96193', 'Filter Coffee', 'PENDING', 20.00, 1, 25, 3, 1);
INSERT INTO public.order_items (id, created_at, food_name, item_status, price, quantity, food_id, order_id, shop_id) VALUES (4, '2026-09-08 23:46:38.962937', 'Chicken Biryani', 'PENDING', 180.00, 1, 19, 3, 1);
INSERT INTO public.order_items (id, created_at, food_name, item_status, price, quantity, food_id, order_id, shop_id) VALUES (5, '2026-09-08 23:51:43.910045', 'Masala Dosa', 'PENDING', 70.00, 1, 5, 4, 1);
INSERT INTO public.order_items (id, created_at, food_name, item_status, price, quantity, food_id, order_id, shop_id) VALUES (6, '2026-09-08 23:59:29.292928', 'Semiya Payasam', 'PENDING', 40.00, 1, 27, 5, 1);
INSERT INTO public.order_items (id, created_at, food_name, item_status, price, quantity, food_id, order_id, shop_id) VALUES (7, '2026-09-09 00:14:28.12489', 'Chicken Biryani', 'PENDING', 180.00, 1, 37, 6, 3);
INSERT INTO public.order_items (id, created_at, food_name, item_status, price, quantity, food_id, order_id, shop_id) VALUES (8, '2026-09-09 00:14:28.128889', 'Mutton Biryani', 'PENDING', 240.00, 1, 38, 6, 3);
INSERT INTO public.order_items (id, created_at, food_name, item_status, price, quantity, food_id, order_id, shop_id) VALUES (10, '2026-09-09 12:10:02.924831', 'Idli', 'PENDING', 30.00, 1, 2, 7, 1);
INSERT INTO public.order_items (id, created_at, food_name, item_status, price, quantity, food_id, order_id, shop_id) VALUES (12, '2026-09-09 12:45:24.51773', 'Chicken Biryani', 'PENDING', 180.00, 1, 37, 8, 3);
INSERT INTO public.order_items (id, created_at, food_name, item_status, price, quantity, food_id, order_id, shop_id) VALUES (13, '2026-09-09 12:45:51.658282', 'Chicken Biryani', 'PENDING', 180.00, 1, 37, 9, 3);
INSERT INTO public.order_items (id, created_at, food_name, item_status, price, quantity, food_id, order_id, shop_id) VALUES (14, '2026-09-09 12:45:51.659283', 'Gobi 65', 'PENDING', 110.00, 2, 43, 9, 3);
INSERT INTO public.order_items (id, created_at, food_name, item_status, price, quantity, food_id, order_id, shop_id) VALUES (9, '2026-09-09 12:10:02.918829', 'Egg Biryani', 'ACCEPTED', 140.00, 1, 20, 7, 1);
INSERT INTO public.order_items (id, created_at, food_name, item_status, price, quantity, food_id, order_id, shop_id) VALUES (11, '2026-09-09 12:10:02.92683', 'Medu Vada', 'ACCEPTED', 35.00, 1, 3, 7, 1);
INSERT INTO public.order_items (id, created_at, food_name, item_status, price, quantity, food_id, order_id, shop_id) VALUES (15, '2026-09-09 13:44:40.992271', 'Idli', 'PENDING', 30.00, 1, 2, 10, 1);
INSERT INTO public.order_items (id, created_at, food_name, item_status, price, quantity, food_id, order_id, shop_id) VALUES (16, '2026-09-09 14:25:14.119093', 'Filter Coffee', 'PENDING', 20.00, 2, 36, 11, 2);
INSERT INTO public.order_items (id, created_at, food_name, item_status, price, quantity, food_id, order_id, shop_id) VALUES (17, '2026-09-09 14:25:14.121769', 'Masala Dosa', 'PENDING', 70.00, 1, 31, 11, 2);
INSERT INTO public.order_items (id, created_at, food_name, item_status, price, quantity, food_id, order_id, shop_id) VALUES (18, '2026-09-09 14:34:48.198606', 'Filter Coffee', 'PENDING', 20.00, 1, 36, 12, 2);
INSERT INTO public.order_items (id, created_at, food_name, item_status, price, quantity, food_id, order_id, shop_id) VALUES (19, '2026-09-09 14:34:48.20262', 'Idli', 'PENDING', 30.00, 1, 28, 12, 2);
INSERT INTO public.order_items (id, created_at, food_name, item_status, price, quantity, food_id, order_id, shop_id) VALUES (20, '2026-09-09 14:36:43.924715', 'Idli', 'PENDING', 30.00, 1, 2, 13, 1);
INSERT INTO public.order_items (id, created_at, food_name, item_status, price, quantity, food_id, order_id, shop_id) VALUES (21, '2026-09-09 14:39:40.303887', 'Idli', 'PENDING', 30.00, 1, 2, 14, 1);


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
-- PostgreSQL database dump complete
--

\unrestrict qZvozywhvmeV9muKf2clPAX0jjNGxWsWQev9C2h27cUHDTSy0jdu24mnCKVL9Hr

