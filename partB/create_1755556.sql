CREATE SCHEMA dating;

SET search_path to dating

CREATE TYPE dating.gender AS ENUM (
    'Male',
    'Female',
    'Other'
)

CREATE TYPE dating.preference AS ENUM (
    'male',
    'female',
    'all'
)

create table dating.user (
    user_id serial primary key,
    email varchar(32) unique,
    phone integer unique,
    password varchar(32) not null,

    CHECK  (
        email is not null OR phone is not null
    )
)

create table dating.location (
    location_id serial primary key,
    city varchar(32) not null,
    province varchar(32) not null,
    country varchar(32) not null,
)

create table dating.profile (
    profile_id serial primary key,
    name varchar(32) not null,
    age integer not null,
    bio text,
    interest text[],
    gender gender not null,
    preference preference not null,
    user_id integer not null 
        REFERENCES dating.user (user_id) 
        on delete cascade,
    location_id integer not null
        REFERENCES dating.location (location_id),
)   

--add trigger to find if user liked them
create table dating.match (
    match_id serial primary key,
    match integer not null 
        references dating.profile (profile_id),
        on delete cascade,
    liked boolean not null default false,
    profile_id integer not null 
        references dating.profile (profile_id),
        on delete cascade
)

create table dating.chat (
    chat_id serial primary key,
    background color default 'white',
    active boolean default true
)

--create trigger if most recent true previous are true
create table dating.message (
    message_id serial primary key,
    message text not null,
    sent timestamp default now(),
    seen boolean default false,
    profile_id integer not null
        references dating.profile (profile_id),
        on delete cascade,
    chat_id integer not null
        references dating.chat (chat_id)
)

create table dating.event (
    event_id serial primary key not null,
    event varchar(32) not null,
    description text,
    time time not null,
    date date not null,
    location_id integer not null
        references dating.location(location_id)
)

create table dating.profile_chat (
    profile_id integer not null
        references dating.profile (profile_id)
        on delete cascade,
    chat_id integer not null
        references dating.chat (chat_id),
    primary key (profile_id, chat_id)
)

create table dating.profile_event (
    profile_id integer not null
        references dating.profile (profile_id)
        on delete cascade,
    event_id integer not null
        references dating.event (event_id),
    primary key (profile_id, event_id)
)


