CREATE TABLE chat_type ( 
	id                   integer NOT NULL  ,
	name                 varchar(10) NOT NULL  ,
	CONSTRAINT pk_chat_type PRIMARY KEY ( id )
 );

CREATE TABLE object_type ( 
	id                   integer NOT NULL  ,
	name                 varchar(100) NOT NULL  ,
	CONSTRAINT pk_object_type PRIMARY KEY ( id )
 );

CREATE TABLE user ( 
	id                   integer NOT NULL  ,
	first_name           text NOT NULL  ,
	last_name            text   ,
	username             text   ,
	CONSTRAINT pk_user PRIMARY KEY ( id )
 );

CREATE TABLE chat ( 
	id                   integer NOT NULL  ,
	"type"               integer NOT NULL  ,
	title                text   ,
	username             integer   ,
	CONSTRAINT pk_chat PRIMARY KEY ( id ),
	FOREIGN KEY ( "type" ) REFERENCES chat_type( id )  ,
	FOREIGN KEY ( username ) REFERENCES user( id )  
 );

CREATE INDEX idx_chat ON chat ( "type" );

CREATE INDEX idx_chat ON chat ( username );

CREATE TABLE contact ( 
	id                   integer NOT NULL  ,
	phone_number         text NOT NULL  ,
	first_name           text NOT NULL  ,
	last_name            text   ,
	user_id              integer   ,
	CONSTRAINT pk_contact PRIMARY KEY ( id ),
	FOREIGN KEY ( user_id ) REFERENCES user( id )  
 );

CREATE INDEX idx_contact ON contact ( user_id );

CREATE TABLE object ( 
	id                   integer NOT NULL  ,
	"type"               integer NOT NULL  ,
	CONSTRAINT pk_object PRIMARY KEY ( id ),
	FOREIGN KEY ( "type" ) REFERENCES object_type( id )  
 );

CREATE INDEX idx_object ON object ( "type" );

CREATE TABLE object_audio ( 
	id                   integer NOT NULL  ,
	audio                text NOT NULL  ,
	duration             integer   ,
	performer            text   ,
	title                text   ,
	mime_type            text   ,
	file_size            integer   ,
	file                 text   ,
	CONSTRAINT pk_object_audio PRIMARY KEY ( id ),
	FOREIGN KEY ( id ) REFERENCES object( id )  
 );

CREATE TABLE object_photo ( 
	id                   integer NOT NULL  ,
	object               integer NOT NULL  ,
	photo                text NOT NULL  ,
	width                integer NOT NULL  ,
	height               integer NOT NULL  ,
	file_size            integer   ,
	file                 text   ,
	CONSTRAINT pk_object_thumbnail PRIMARY KEY ( id ),
	FOREIGN KEY ( object ) REFERENCES object( id )  
 );

CREATE INDEX idx_thumbnail ON object_photo ( object );

CREATE TABLE object_sticker ( 
	id                   integer NOT NULL  ,
	sticker              text NOT NULL  ,
	width                integer NOT NULL  ,
	height               integer NOT NULL  ,
	thumbnail            integer   ,
	file_size            integer   ,
	file                 text   ,
	CONSTRAINT pk_object_sticker PRIMARY KEY ( id ),
	FOREIGN KEY ( id ) REFERENCES object( id )  ,
	FOREIGN KEY ( thumbnail ) REFERENCES object_photo( id )  
 );

CREATE INDEX idx_object_sticker ON object_sticker ( thumbnail );

CREATE TABLE object_text ( 
	id                   integer NOT NULL  ,
	"text"               text NOT NULL  ,
	CONSTRAINT pk_object_text PRIMARY KEY ( id ),
	FOREIGN KEY ( id ) REFERENCES object( id )  
 );

CREATE TABLE object_video ( 
	id                   integer NOT NULL  ,
	video                text NOT NULL  ,
	width                integer NOT NULL  ,
	height               integer NOT NULL  ,
	duration             integer NOT NULL  ,
	thumbnail            integer   ,
	mime_type            text   ,
	file_size            integer   ,
	file                 text   ,
	CONSTRAINT pk_object_video PRIMARY KEY ( id ),
	FOREIGN KEY ( id ) REFERENCES object( id )  ,
	FOREIGN KEY ( thumbnail ) REFERENCES object_photo( id )  
 );

CREATE INDEX idx_object_video ON object_video ( thumbnail );

CREATE TABLE object_voice ( 
	id                   integer NOT NULL  ,
	voice                text NOT NULL  ,
	duration             integer NOT NULL  ,
	mime_type            text   ,
	file_size            integer   ,
	file                 text   ,
	CONSTRAINT pk_object_voice PRIMARY KEY ( id ),
	FOREIGN KEY ( id ) REFERENCES object( id )  
 );

CREATE TABLE object_document ( 
	id                   integer NOT NULL  ,
	document             integer NOT NULL  ,
	thumbnail            integer   ,
	file_name            text   ,
	mime_type            text   ,
	file_size            integer   ,
	file                 text   ,
	CONSTRAINT pk_object_document PRIMARY KEY ( id ),
	FOREIGN KEY ( id ) REFERENCES object( id )  ,
	FOREIGN KEY ( thumbnail ) REFERENCES object_photo( id )  
 );

CREATE INDEX idx_object_document ON object_document ( thumbnail );

CREATE TABLE message ( 
	id                   integer NOT NULL  ,
	from_user            integer   ,
	date                 integer NOT NULL  ,
	chat                 integer NOT NULL  ,
	forward_from_user    integer   ,
	forward_date         integer   ,
	reply_to_message     integer   ,
	object               integer NOT NULL  ,
	new_chat_participant integer   ,
	left_chat_participant integer   ,
	new_chat_title       text   ,
	new_chat_photo       integer   ,
	delete_chat_photo    boolean   ,
	group_chat_created   boolean   ,
	supergroup_chat_created boolean   ,
	channel_chat_created boolean   ,
	migrate_to_chat_id   integer   ,
	migrate_from_chat_id integer   ,
	CONSTRAINT pk_message PRIMARY KEY ( id )
 );

CREATE INDEX idx_message ON message ( from_user );

CREATE INDEX idx_message ON message ( chat );

CREATE INDEX idx_message ON message ( forward_from_user );

CREATE INDEX idx_message ON message ( reply_to_message );

CREATE INDEX idx_message ON message ( object );

CREATE INDEX idx_message ON message ( new_chat_participant );

CREATE INDEX idx_message ON message ( left_chat_participant );

CREATE INDEX idx_message ON message ( migrate_to_chat_id );

CREATE INDEX idx_message ON message ( migrate_from_chat_id );

CREATE INDEX idx_message ON message ( new_chat_photo );

