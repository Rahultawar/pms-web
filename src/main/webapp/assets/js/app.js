(function () {
    'use strict';

    // ==================== SEARCH FUNCTIONALITY ====================
    function initSearch() {
        const searchBox = document.getElementById('searchBox');
        if (!searchBox) return;

        const page = document.body.dataset.page || '';
        let tableSelector = '';
        
        if (page === 'product') tableSelector = '#productTable tbody';
        else if (page === 'distributor') tableSelector = '#distributorTable tbody';
        else if (page === 'sale') tableSelector = '#saleTable tbody';
        
        if (!tableSelector) return;

        searchBox.addEventListener('input', function (e) {
            const searchTerm = e.target.value.toLowerCase();
            const tbody = document.querySelector(tableSelector);
            if (!tbody) return;

            const rows = tbody.querySelectorAll('tr');
            rows.forEach(row => {
                const text = row.textContent.toLowerCase();
                row.style.display = text.includes(searchTerm) ? '' : 'none';
            });
        });
    }

    // ==================== FORM VALIDATION ====================
    function initFormValidation() {
        const forms = document.querySelectorAll('form');
        forms.forEach(form => {
            const inputs = form.querySelectorAll('input[required], select[required], textarea[required]');
            inputs.forEach(input => {
                input.addEventListener('blur', function () {
                    if (!input.checkValidity()) {
                        input.classList.add('is-invalid');
                    } else {
                        input.classList.remove('is-invalid');
                        input.classList.add('is-valid');
                    }
                });
            });
        });
    }

    // ==================== EXISTING FUNCTIONS ====================
    function toggleStripDetails() {
        var unitEl = document.getElementById('unit');
        var stripDetails = document.getElementsByClassName('stripDetails');
        if (!unitEl || !stripDetails.length) return;
        var show = unitEl.value && unitEl.value.toLowerCase() === 'strip';
            if (!unitEl.dataset.stripBound) {
                unitEl.addEventListener('change', toggleStripDetails);
                unitEl.dataset.stripBound = 'true';
            }
        for (var i = 0; i < stripDetails.length; i++) {
            var container = stripDetails[i];
            if (show) {
                container.classList.add('is-visible');
            } else {
                container.classList.remove('is-visible');
            }
            var field = container.querySelector('input, select, textarea');
            if (!field) continue;
            if (show) {
                field.removeAttribute('disabled');
                if (field.dataset.stripRequired === 'true') {
                    field.setAttribute('required', 'required');
                }
            } else {
                if (field.tagName === 'SELECT') {
                    field.selectedIndex = 0;
                } else {
                    field.value = '';
                }
                field.setAttribute('disabled', 'disabled');
                if (field.dataset.stripRequired === 'true') {
                    field.removeAttribute('required');
                }
            }
        }
    }

    function showForm(mode) {
        var page = document.body.dataset.page || '';

        // Hide header for all form modes
        var header = document.querySelector('.app-header');
        if (header) header.style.display = 'none';
        
        if (page === 'sale') {
            var saleForm = document.getElementById('saleForm');
            if (!saleForm) return;
            saleForm.style.display = 'block';

            var addSaleBtn = document.querySelector('[data-action="show-form"][data-mode="add"]');
            if (addSaleBtn) addSaleBtn.style.display = 'none';

            var search = document.getElementById('searchBox');
            if (search) search.style.display = 'none';

            var saleTable = document.getElementById('saleTable');
            if (saleTable) saleTable.style.display = 'none';

            var noSaleBox = document.getElementById('noSaleAvailable');
            if (noSaleBox) noSaleBox.style.display = 'none';

            var breadcrumbSale = document.getElementById('breadcrumbItem');
            if (breadcrumbSale) {
                var existingCrumb = breadcrumbSale.querySelector('.dynamic-crumb');
                if (existingCrumb) existingCrumb.remove();
                var crumb = document.createElement('li');
                crumb.className = 'breadcrumb-item active dynamic-crumb';
                crumb.setAttribute('aria-current', 'page');
                crumb.innerText = mode === 'edit' ? 'Edit Sale' : 'Add Sale';
                breadcrumbSale.appendChild(crumb);
            }

            var saleFormTitle = document.getElementById('formTitle');
            if (saleFormTitle) saleFormTitle.textContent = mode === 'edit' ? 'Edit Sale' : 'Add New Sale';

            var resetSaleBtn = document.getElementById('btnReset');
            if (resetSaleBtn) resetSaleBtn.style.display = mode === 'edit' ? 'none' : 'inline-block';

            setTimeout(function () {
                saleForm.scrollIntoView({ behavior: 'smooth' });
            }, 50);
            return;
        }

        var formId = page === 'distributor' ? 'distributorForm' : 'productForm';
        var form = document.getElementById(formId);
        if (!form) return;
        form.style.display = 'block';

        // hide add button and search
        var addBtn = document.querySelector('[data-action="show-form"][data-mode="add"]');
        if (addBtn) addBtn.style.display = 'none';
        var searchBox = document.getElementById('searchBox');
        if (searchBox) searchBox.style.display = 'none';

        // hide table / no-data box
        var table = document.getElementById(page === 'distributor' ? 'distributorTable' : 'productTable');
        if (table) table.style.display = 'none';
        var noBox = document.getElementById(page === 'distributor' ? 'noDistributorAvailable' : 'noProductAvailable');
        if (noBox) noBox.style.display = 'none';

        // breadcrumb
        var breadcrumb = document.getElementById('breadcrumbItem');
        if (breadcrumb) {
            var existing = breadcrumb.querySelector('.dynamic-crumb');
            if (existing) existing.remove();
            var li = document.createElement('li');
            li.className = 'breadcrumb-item active dynamic-crumb';
            li.setAttribute('aria-current', 'page');
            li.innerText = mode === 'edit' ? (page === 'distributor' ? 'Edit Distributor' : 'Edit Product') : (page === 'distributor' ? 'Add Distributor' : 'Add Product');
            breadcrumb.appendChild(li);
        }

        if (mode === 'edit') {
            var formTitle = document.getElementById('formTitle');
            if (formTitle) formTitle.textContent = page === 'distributor' ? 'Edit Distributor' : 'Edit Product';
            var resetBtn = document.getElementById('btnReset');
            if (resetBtn) resetBtn.style.display = 'none';
        }

        // scroll form into view nicely
        setTimeout(function () {
            form.scrollIntoView({ behavior: 'smooth' });
        }, 50);
    }

    function bindClicks() {
        document.addEventListener('click', function (e) {
            var confirmTarget = e.target.closest('[data-confirm]');
            if (confirmTarget) {
                var message = confirmTarget.dataset.confirm || 'Are you sure?';
                if (!window.confirm(message)) {
                    e.preventDefault();
                    e.stopImmediatePropagation();
                    return;
                }
            }

            var t = e.target.closest('[data-action]');
            if (!t) return;
            var action = t.dataset.action;
            if (action === 'show-form') {
                e.preventDefault();
                var mode = t.dataset.mode || 'add';
                showForm(mode);
            }
        });
    }

    // ==================== CHECK URL PARAMETERS ====================
    function checkUrlStatus() {
        const urlParams = new URLSearchParams(window.location.search);
        const errorMsg = urlParams.get('error');
        if (errorMsg) {
            alert('Error: ' + decodeURIComponent(errorMsg));
        }
    }

    // ==================== PRODUCT SELECTION AUTO-POPULATE ====================
    function initProductSelection() {
        const productSelect = document.getElementById('selProduct');
        if (!productSelect) return;

        productSelect.addEventListener('change', function() {
            const selectedOption = this.options[this.selectedIndex];
            
            if (!selectedOption || !selectedOption.value) {
                // Clear fields if no product selected
                document.getElementById('unit').value = '';
                document.getElementById('unitPerStrip').value = '';
                document.getElementById('unitPrice').value = '';
                document.getElementById('selDistributor').value = '';
                document.getElementById('totalAmount').value = '';
                return;
            }

            // Get data attributes from selected option
            const unit = selectedOption.getAttribute('data-unit') || '';
            const unitsPerStrip = selectedOption.getAttribute('data-units-per-strip') || '';
            const sellingPrice = selectedOption.getAttribute('data-selling-price') || '';
            const distributorId = selectedOption.getAttribute('data-distributor-id') || '';

            // Set the form fields
            const unitField = document.getElementById('unit');
            const unitPerStripField = document.getElementById('unitPerStrip');
            const unitPriceField = document.getElementById('unitPrice');
            const distributorField = document.getElementById('selDistributor');

            if (unitField) unitField.value = unit;
            if (unitPerStripField) unitPerStripField.value = unitsPerStrip;
            if (unitPriceField) unitPriceField.value = sellingPrice;
            if (distributorField && distributorId) {
                distributorField.value = distributorId;
            }

            // Calculate total amount if quantity is already entered
            calculateTotalAmount();
        });

        // Also add listeners to quantity, unit price, and discount to recalculate total
        const quantityField = document.getElementById('quantity');
        const unitPriceField = document.getElementById('unitPrice');
        const discountField = document.getElementById('discountAmount');

        if (quantityField) {
            quantityField.addEventListener('input', calculateTotalAmount);
        }
        if (unitPriceField) {
            unitPriceField.addEventListener('input', calculateTotalAmount);
        }
        if (discountField) {
            discountField.addEventListener('input', calculateTotalAmount);
        }
    }

    function calculateTotalAmount() {
        const quantityField = document.getElementById('quantity');
        const unitPriceField = document.getElementById('unitPrice');
        const discountField = document.getElementById('discountAmount');
        const totalAmountField = document.getElementById('totalAmount');

        if (!quantityField || !unitPriceField || !totalAmountField) return;

        const quantity = parseFloat(quantityField.value) || 0;
        const unitPrice = parseFloat(unitPriceField.value) || 0;
        const discount = parseFloat(discountField ? discountField.value : 0) || 0;

        const subtotal = quantity * unitPrice;
        const total = subtotal - discount;

        totalAmountField.value = total >= 0 ? total.toFixed(2) : '0.00';
    }

    // ==================== INITIALIZE ALL FEATURES ====================
    function init() {
        bindClicks();
        initSearch();
        initFormValidation();
        checkUrlStatus();
        initMobileMenu();
        
        // page specific init
        var page = document.body.dataset.page || '';
        if (page === 'product') {
            toggleStripDetails();
        }
        if (page === 'sale') {
            initProductSelection();
        }
    }

    // ==================== MOBILE MENU TOGGLE ====================
    function initMobileMenu() {
        // Create mobile menu toggle button
        const toggleBtn = document.createElement('button');
        toggleBtn.className = 'mobile-menu-toggle';
        toggleBtn.innerHTML = '<i class="fas fa-bars"></i>';
        toggleBtn.setAttribute('aria-label', 'Toggle Menu');
        document.body.appendChild(toggleBtn);

        // Create overlay
        const overlay = document.createElement('div');
        overlay.className = 'sidebar-overlay';
        document.body.appendChild(overlay);

        const sidebar = document.getElementById('sidebar');
        if (!sidebar) return;

        // Toggle menu
        toggleBtn.addEventListener('click', function() {
            sidebar.classList.toggle('active');
            overlay.classList.toggle('active');
        });

        // Close on overlay click
        overlay.addEventListener('click', function() {
            sidebar.classList.remove('active');
            overlay.classList.remove('active');
        });

        // Close on nav link click (mobile)
        const navLinks = sidebar.querySelectorAll('.nav-link');
        navLinks.forEach(link => {
            link.addEventListener('click', function() {
                if (window.innerWidth <= 992) {
                    sidebar.classList.remove('active');
                    overlay.classList.remove('active');
                }
            });
        });
    }

    // public API
    window.PMS = {
        init: init,
        showForm: showForm
    };

    document.addEventListener('DOMContentLoaded', init);
})();
