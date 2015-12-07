CREATE SCHEMA telegram;

CREATE TABLE telegram.chat_type ( 
	id                   int  NOT NULL  ,
	name                 varchar(10)  NOT NULL  ,
	CONSTRAINT pk_chat_type PRIMARY KEY ( id )
 );

ALTER TABLE telegram.chat_type COMMENT 'Типы чатов';

CREATE TABLE telegram.object_type ( 
	id                   int  NOT NULL  ,
	name                 varchar(100)  NOT NULL  ,
	CONSTRAINT pk_object_type PRIMARY KEY ( id )
 );

CREATE TABLE telegram.`user` ( 
	id                   mediumint  NOT NULL  ,
	first_name           text  NOT NULL  ,
	last_name            text    ,
	username             text    ,
	CONSTRAINT pk_user PRIMARY KEY ( id )
 );

CREATE TABLE telegram.chat ( 
	id                   mediumint  NOT NULL  ,
	`type`               mediumint  NOT NULL  ,
	title                text    ,
	username             mediumint    ,
	CONSTRAINT pk_chat PRIMARY KEY ( id )
 );

CREATE INDEX idx_chat ON telegram.chat ( `type` );

CREATE INDEX idx_chat ON telegram.chat ( username );

CREATE TABLE telegram.contact ( 
	id                   int  NOT NULL  ,
	phone_number         text  NOT NULL  ,
	first_name           text  NOT NULL  ,
	last_name            text    ,
	user_id              mediumint    ,
	CONSTRAINT pk_contact PRIMARY KEY ( id )
 );

CREATE INDEX idx_contact ON telegram.contact ( user_id );

CREATE TABLE telegram.object ( 
	id                   int  NOT NULL  ,
	`type`               mediumint  NOT NULL  ,
	CONSTRAINT pk_object PRIMARY KEY ( id )
 );

CREATE INDEX idx_object ON telegram.object ( `type` );

CREATE TABLE telegram.object_audio ( 
	id                   mediumint  NOT NULL  ,
	audio                text  NOT NULL  ,
	duration             mediumint    ,
	performer            text    ,
	title                text    ,
	mime_type            text    ,
	file_size            mediumint    ,
	file                 text    ,
	CONSTRAINT pk_object_audio PRIMARY KEY ( id )
 );

CREATE TABLE telegram.object_photo ( 
	id                   int  NOT NULL  ,
	object               mediumint  NOT NULL  ,
	photo                text  NOT NULL  ,
	width                mediumint  NOT NULL  ,
	height               mediumint  NOT NULL  ,
	file_size            mediumint    ,
	file                 text    ,
	CONSTRAINT pk_object_thumbnail PRIMARY KEY ( id )
 );

CREATE INDEX idx_thumbnail ON telegram.object_photo ( object );

CREATE TABLE telegram.object_sticker ( 
	id                   mediumint  NOT NULL  ,
	sticker              text  NOT NULL  ,
	width                mediumint  NOT NULL  ,
	height               mediumint  NOT NULL  ,
	thumbnail            mediumint    ,
	file_size            mediumint    ,
	file                 text    ,
	CONSTRAINT pk_object_sticker PRIMARY KEY ( id )
 );

CREATE INDEX idx_object_sticker ON telegram.object_sticker ( thumbnail );

CREATE TABLE telegram.object_text ( 
	id                   mediumint  NOT NULL  ,
	`text`               text  NOT NULL  ,
	CONSTRAINT pk_object_text PRIMARY KEY ( id )
 );

CREATE TABLE telegram.object_video ( 
	id                   mediumint  NOT NULL  ,
	video                text  NOT NULL  ,
	width                mediumint  NOT NULL  ,
	height               mediumint  NOT NULL  ,
	duration             mediumint  NOT NULL  ,
	thumbnail            mediumint    ,
	mime_type            text    ,
	file_size            mediumint    ,
	file                 text    ,
	CONSTRAINT pk_object_video PRIMARY KEY ( id )
 );

CREATE INDEX idx_object_video ON telegram.object_video ( thumbnail );

CREATE TABLE telegram.object_voice ( 
	id                   mediumint  NOT NULL  ,
	voice                text  NOT NULL  ,
	duration             mediumint  NOT NULL  ,
	mime_type            text    ,
	file_size            mediumint    ,
	file                 text    ,
	CONSTRAINT pk_object_voice PRIMARY KEY ( id )
 );

CREATE TABLE telegram.object_document ( 
	id                   mediumint  NOT NULL  ,
	document             mediumint  NOT NULL  ,
	thumbnail            mediumint    ,
	file_name            text    ,
	mime_type            text    ,
	file_size            mediumint    ,
	file                 text    ,
	CONSTRAINT pk_object_document PRIMARY KEY ( id )
 );

CREATE INDEX idx_object_document ON telegram.object_document ( thumbnail );

CREATE TABLE telegram.message ( 
	id                   mediumint  NOT NULL  ,
	from_user            mediumint    ,
	`date`               mediumint  NOT NULL  ,
	chat                 mediumint  NOT NULL  ,
	forward_from_user    mediumint    ,
	forward_date         mediumint    ,
	reply_to_message     mediumint    ,
	object               mediumint  NOT NULL  ,
	new_chat_participant mediumint    ,
	left_chat_participant mediumint    ,
	new_chat_title       text    ,
	new_chat_photo       mediumint    ,
	delete_chat_photo    bool    ,
	group_chat_created   bool    ,
	supergroup_chat_created bool    ,
	channel_chat_created bool    ,
	migrate_to_chat_id   mediumint    ,
	migrate_from_chat_id mediumint    ,
	CONSTRAINT pk_message PRIMARY KEY ( id )
 );

CREATE INDEX idx_message ON telegram.message ( from_user );

CREATE INDEX idx_message ON telegram.message ( chat );

CREATE INDEX idx_message ON telegram.message ( forward_from_user );

CREATE INDEX idx_message ON telegram.message ( reply_to_message );

CREATE INDEX idx_message ON telegram.message ( object );

CREATE INDEX idx_message ON telegram.message ( new_chat_participant );

CREATE INDEX idx_message ON telegram.message ( left_chat_participant );

CREATE INDEX idx_message ON telegram.message ( migrate_to_chat_id );

CREATE INDEX idx_message ON telegram.message ( migrate_from_chat_id );

CREATE INDEX idx_message ON telegram.message ( new_chat_photo );

ALTER TABLE telegram.chat ADD CONSTRAINT fk_chat_chat_type FOREIGN KEY ( `type` ) REFERENCES telegram.chat_type( id ) ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE telegram.chat ADD CONSTRAINT fk_chat_user FOREIGN KEY ( username ) REFERENCES telegram.`user`( id ) ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE telegram.contact ADD CONSTRAINT fk_contact_user FOREIGN KEY ( user_id ) REFERENCES telegram.`user`( id ) ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE telegram.message ADD CONSTRAINT fk_message_user FOREIGN KEY ( from_user ) REFERENCES telegram.`user`( id ) ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE telegram.message ADD CONSTRAINT fk_message_chat FOREIGN KEY ( chat ) REFERENCES telegram.chat( id ) ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE telegram.message ADD CONSTRAINT fk_message_forward_user FOREIGN KEY ( forward_from_user ) REFERENCES telegram.`user`( id ) ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE telegram.message ADD CONSTRAINT fk_message_message FOREIGN KEY ( reply_to_message ) REFERENCES telegram.message( id ) ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE telegram.message ADD CONSTRAINT fk_message_object FOREIGN KEY ( object ) REFERENCES telegram.object( id ) ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE telegram.message ADD CONSTRAINT fk_message_add_user FOREIGN KEY ( new_chat_participant ) REFERENCES telegram.`user`( id ) ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE telegram.message ADD CONSTRAINT fk_message_left_user FOREIGN KEY ( left_chat_participant ) REFERENCES telegram.`user`( id ) ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE telegram.message ADD CONSTRAINT fk_message_migrate_to_chat FOREIGN KEY ( migrate_to_chat_id ) REFERENCES telegram.chat( id ) ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE telegram.message ADD CONSTRAINT fk_message_migrate_from_chat FOREIGN KEY ( migrate_from_chat_id ) REFERENCES telegram.chat( id ) ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE telegram.message ADD CONSTRAINT fk_message_chat_photo_object FOREIGN KEY ( new_chat_photo ) REFERENCES telegram.object( id ) ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE telegram.object ADD CONSTRAINT fk_object_object_type FOREIGN KEY ( `type` ) REFERENCES telegram.object_type( id ) ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE telegram.object_audio ADD CONSTRAINT fk_object_audio_object FOREIGN KEY ( id ) REFERENCES telegram.object( id ) ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE telegram.object_document ADD CONSTRAINT fk_object_document_object FOREIGN KEY ( id ) REFERENCES telegram.object( id ) ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE telegram.object_document ADD CONSTRAINT fk_object_document_thumbnail FOREIGN KEY ( thumbnail ) REFERENCES telegram.object_photo( id ) ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE telegram.object_photo ADD CONSTRAINT fk_thumbnail_object FOREIGN KEY ( object ) REFERENCES telegram.object( id ) ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE telegram.object_sticker ADD CONSTRAINT fk_object_sticker_object FOREIGN KEY ( id ) REFERENCES telegram.object( id ) ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE telegram.object_sticker ADD CONSTRAINT fk_object_sticker_thumbnail FOREIGN KEY ( thumbnail ) REFERENCES telegram.object_photo( id ) ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE telegram.object_text ADD CONSTRAINT fk_object_text_object FOREIGN KEY ( id ) REFERENCES telegram.object( id ) ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE telegram.object_video ADD CONSTRAINT fk_object_video_object FOREIGN KEY ( id ) REFERENCES telegram.object( id ) ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE telegram.object_video ADD CONSTRAINT fk_object_video_thumbnail FOREIGN KEY ( thumbnail ) REFERENCES telegram.object_photo( id ) ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE telegram.object_voice ADD CONSTRAINT fk_object_voice_object FOREIGN KEY ( id ) REFERENCES telegram.object( id ) ON DELETE NO ACTION ON UPDATE NO ACTION;

