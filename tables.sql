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

CREATE TABLE `customer` (
  `customerId` INT NOT NULL AUTO_INCREMENT,
  `customerName` VARCHAR(255) NOT NULL,
  `contactNumber` VARCHAR(20) NOT NULL,
  `userId` INT NOT NULL,
  `createdAt` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`customerId`),
  KEY `idx_customer_user` (`userId`),
  CONSTRAINT fk_customer_user
  FOREIGN KEY (userId) REFERENCES user(userId)
  ON DELETE CASCADE
  ON UPDATE CASCADE
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

CREATE TABLE `sale` (
  `saleId` INT NOT NULL AUTO_INCREMENT,
  `customerId` INT DEFAULT NULL,
  `userId` INT NOT NULL,
  `productId` INT NOT NULL,
  `distributorId` INT NOT NULL,
  `quantity` INT NOT NULL,
  `subQuantity` INT DEFAULT NULL,
  `paymentMethod` VARCHAR(255) NOT NULL,
  `saleDate` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `discount` DECIMAL(13,2) DEFAULT 0,
  `totalAmount` DECIMAL(13,2) NOT NULL,
  `amountGivenByCustomer` DECIMAL(13,2) NOT NULL,
  `status` VARCHAR(255) NOT NULL DEFAULT 'pending',
  `createdAt` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`saleId`),
  KEY `idx_sale_customer` (`customerId`),
  KEY `idx_sale_user` (`userId`),
  KEY `idx_sale_product` (`productId`),
  KEY `idx_sale_distributor` (`distributorId`),
  CONSTRAINT `fk_sale_customer`
    FOREIGN KEY (`customerId`) REFERENCES `customer`(`customerId`)
    ON DELETE SET NULL
    ON UPDATE CASCADE,
  CONSTRAINT `fk_sale_user`
    FOREIGN KEY (`userId`) REFERENCES `user`(`userId`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_sale_product`
    FOREIGN KEY (`productId`) REFERENCES `product`(`productId`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_sale_distributor`
    FOREIGN KEY (`distributorId`) REFERENCES `distributor`(`distributorId`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;