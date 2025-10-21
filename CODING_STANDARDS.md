# CODING STANDARDS
#### Classes
- Use **PascalCase** for class names
- Class names should be nouns
- Examples: `ProductDAO`, `DistributorServlet`, `Sale`

#### Methods
- Use **camelCase** for method names
- Method names should be verbs
- Examples: `getAllProducts()`, `deleteDistributor()`, `calculateTotal()`

#### Variables
- Use **camelCase** for variable names
- Use descriptive names that indicate purpose
- Examples: `productName`, `totalAmount`, `distributorId`

#### Constants
- Use **UPPER_SNAKE_CASE** for constants
- Examples: `MAX_ITEMS_PER_PAGE`, `DEFAULT_TIMEOUT`, `DATABASE_URL`

#### Packages
- Use **lowercase** for package names
- Use reverse domain notation
- Examples: `com.inventory.dao`, `com.inventory.models`

### CODE FORMATTING

#### Indentation
- Use **4 spaces** for indentation (no tabs)
- Maintain consistent indentation throughout the file

#### Line Length
- Maximum line length: **120 characters**
- Break long lines at logical points
- Align wrapped lines properly



## JSP CODING STANDARDS

### STRUCTURE
- Separate concerns: use JSTL/EL instead of scriptlets
- Avoid Java code in JSP files
- Use tag libraries for logic

### NAMING CONVENTIONS
- JSP file names should be **lowercase** with hyphens
- Examples: `product.jsp`, `distributor.jsp`, `dashboard.jsp`

### COMMENTS
- Use HTML comments for markup explanations
- **ALL COMMENTS MUST BE IN UPPER CASE**
```jsp
<!-- PRODUCT FORM SECTION -->
<div class="form-card">
    <!-- FORM CONTENT -->
</div>
```

### JSTL USAGE
- Use JSTL tags instead of scriptlets
- Use EL (Expression Language) for data access
```jsp
<c:forEach var="product" items="${productList}">
    <td>${product.productName}</td>
</c:forEach>
```

---

## CSS CODING STANDARDS

### NAMING CONVENTIONS
- Use **kebab-case** for class names
- Use semantic, descriptive names
- Examples: `.form-card`, `.table-responsive`, `.btn-primary`

### ORGANIZATION
- Group related styles together
- Order properties logically (layout → visual → typography)
- Use shorthand properties when possible

### COMMENTS
- **ALL COMMENTS MUST BE IN UPPER CASE**
- Group related sections with comments
```css
/* PRIMARY BUTTON STYLES */
.btn-primary {
    background-color: #007bff;
    color: white;
}
```

---

## JAVASCRIPT CODING STANDARDS

### NAMING CONVENTIONS
- Use **camelCase** for variables and functions
- Use **PascalCase** for constructors and classes
- Use **UPPER_SNAKE_CASE** for constants
- Examples: `productName`, `addProduct()`, `MAX_RETRY_ATTEMPTS`

### CODE STYLE
- Use `const` for variables that don't change
- Use `let` for variables that do change
- Avoid `var`
- Use template literals for string concatenation
```javascript
const message = `Product ${productName} added successfully`;
```

### COMMENTS
- **ALL COMMENTS MUST BE IN UPPER CASE**
```javascript
// VALIDATE FORM BEFORE SUBMISSION
function validateForm() {
    // VALIDATION LOGIC
}
```

---

## DATABASE STANDARDS

### TABLE NAMING
- Use **lowercase** with **underscores**
- Use singular names for tables
- Examples: `product`, `distributor`, `sale`

### COLUMN NAMING
- Use **camelCase** for column names
- Use descriptive names
- Examples: `productId`, `sellingPrice`, `createdAt`

### FOREIGN KEYS
- Name foreign keys with format: `tableName_columnName`
- Examples: `product_distributorId`
