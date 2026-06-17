CREATE TABLE `events` (
	`id` text PRIMARY KEY NOT NULL,
	`host_id` text NOT NULL,
	`name` text NOT NULL,
	`description` text,
	`max_guests` integer DEFAULT 5 NOT NULL,
	`max_photos_per_guest` integer DEFAULT 10 NOT NULL,
	`reveal_at` integer NOT NULL,
	`status` text DEFAULT 'draft' NOT NULL,
	`qr_code` text,
	`created_at` integer NOT NULL,
	`updated_at` integer NOT NULL,
	FOREIGN KEY (`host_id`) REFERENCES `users`(`id`) ON UPDATE no action ON DELETE no action
);
--> statement-breakpoint
CREATE TABLE `guest_sessions` (
	`id` text PRIMARY KEY NOT NULL,
	`event_id` text NOT NULL,
	`device_id` text NOT NULL,
	`nickname` text,
	`photos_count` integer DEFAULT 0 NOT NULL,
	`joined_at` integer NOT NULL,
	FOREIGN KEY (`event_id`) REFERENCES `events`(`id`) ON UPDATE no action ON DELETE no action
);
--> statement-breakpoint
CREATE TABLE `photos` (
	`id` text PRIMARY KEY NOT NULL,
	`event_id` text NOT NULL,
	`guest_session_id` text NOT NULL,
	`r2_key` text NOT NULL,
	`filter` text DEFAULT 'none' NOT NULL,
	`taken_at` integer NOT NULL,
	`created_at` integer NOT NULL,
	FOREIGN KEY (`event_id`) REFERENCES `events`(`id`) ON UPDATE no action ON DELETE no action
);
--> statement-breakpoint
CREATE TABLE `purchases` (
	`id` text PRIMARY KEY NOT NULL,
	`user_id` text NOT NULL,
	`product_id` text NOT NULL,
	`tier` text NOT NULL,
	`amount_eur` real NOT NULL,
	`apple_tx_id` text NOT NULL,
	`environment` text NOT NULL,
	`purchased_at` integer NOT NULL,
	`created_at` integer NOT NULL,
	FOREIGN KEY (`user_id`) REFERENCES `users`(`id`) ON UPDATE no action ON DELETE no action
);
--> statement-breakpoint
CREATE UNIQUE INDEX `purchases_apple_tx_id_unique` ON `purchases` (`apple_tx_id`);--> statement-breakpoint
CREATE TABLE `users` (
	`id` text PRIMARY KEY NOT NULL,
	`apple_subject` text NOT NULL,
	`email` text,
	`name` text,
	`tier` text DEFAULT 'free' NOT NULL,
	`created_at` integer NOT NULL,
	`updated_at` integer NOT NULL
);
--> statement-breakpoint
CREATE UNIQUE INDEX `users_apple_subject_unique` ON `users` (`apple_subject`);