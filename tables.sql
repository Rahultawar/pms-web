CREATE TABLE `user` (
  `userId` INT NOT NULL AUTO_INCREMENT,
  `userName` VARCHAR(100) NOT NULL,
  `password` VARCHAR(255) NOT NULL,
  `medicalStoreName` VARCHAR(255) NOT NULL,
  `medicalStoreLogo` VARCHAR(255) NOT NULL,
  `createdAt` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`userId`),
  UNIQUE KEY `ux_user_userName` (`userName`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE product (
  `productId` INT NOT NULL AUTO_INCREMENT,
  `productName` VARCHAR(255) NOT NULL,
  `distributorId` INT NOT NULL,
  `userId` INT DEFAULT NULL,
  `quantity` INT NOT NULL,
  `subQuantity` INT DEFAULT NULL,
  `unit` VARCHAR(50) NOT NULL,
  `location` VARCHAR(255) DEFAULT NULL,
  `strength` VARCHAR(100) NOT NULL,
  `category` VARCHAR(100) NOT NULL,
  `manufacturer` VARCHAR(255) DEFAULT NULL,
  `manufacturingDate` DATE NOT NULL,
  `expiryDate` DATE NOT NULL,
  `purchasingPrice` DECIMAL(13,2) NOT NULL,
  `batchNumber` VARCHAR(100) NOT NULL,
  `sellingPrice` DECIMAL(13,2) NOT NULL,
  `reorderLevel` INT DEFAULT 0,
  `createdAt` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`productId`),
  UNIQUE KEY `ux_batch_number` (`batchNumber`),
  KEY `idx_product_distributor` (`distributorId`),
  KEY `idx_product_user` (`userId`),
  CONSTRAINT `fk_product_distributor` FOREIGN KEY (`distributorId`) REFERENCES `distributor`(`distributorId`) ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT `fk_product_user` FOREIGN KEY (`userId`) REFERENCES `user`(`userId`) ON UPDATE CASCADE ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `distributor` (
  `distributorId` INT NOT NULL AUTO_INCREMENT,
  `distributorName` VARCHAR(255) NOT NULL,
  `userId` INT DEFAULT NULL,
  `contactPerson` VARCHAR(255) DEFAULT NULL,
  `email` VARCHAR(100) NOT NULL,
  `phone` VARCHAR(10) NOT NULL,
  `address` VARCHAR(255) DEFAULT NULL,
  `city` VARCHAR(100) DEFAULT NULL,
  `state` VARCHAR(100) DEFAULT NULL,
  `pinCode` VARCHAR(100) DEFAULT NULL,
  `createdAt` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`distributorId`),
  UNIQUE KEY `ux_distributor_name` (`distributorName`),
  CONSTRAINT fk_distributor_user 
  FOREIGN KEY (userId) REFERENCES user(userId) 
  ON DELETE CASCADE 
  ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;