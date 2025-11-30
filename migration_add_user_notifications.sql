-- Migration to add user_notifications table
-- Run this script on existing databases to add the notifications read status functionality

CREATE TABLE IF NOT EXISTS `user_notifications` (
  `notificationId` INT NOT NULL AUTO_INCREMENT,
  `userId` INT NOT NULL,
  `productId` INT NOT NULL,
  `notificationType` ENUM('low_stock', 'expiry') NOT NULL,
  `isRead` TINYINT(1) DEFAULT 0,
  `createdAt` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`notificationId`),
  UNIQUE KEY `ux_user_notification` (`userId`, `productId`, `notificationType`),
  KEY `idx_user_notifications_user` (`userId`),
  KEY `idx_user_notifications_product` (`productId`),
  CONSTRAINT `fk_user_notifications_user` FOREIGN KEY (`userId`) REFERENCES `user`(`userId`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_user_notifications_product` FOREIGN KEY (`productId`) REFERENCES `product`(`productId`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
