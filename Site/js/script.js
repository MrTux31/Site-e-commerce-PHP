// Variable pour l'état visuel du code promo
let promoApplied = false;

/** Met à jour l'affichage de la barre de promotion (visuel uniquement) */
function updatePromoMessage() {
    const promoMessage = document.getElementById('promo-message');
    if (!promoMessage) return;

    if (promoApplied) {
        promoMessage.textContent = 'Promotion MAGIC2024 appliquée (visuel uniquement).';
        promoMessage.classList.add('text-yellow-900', 'bg-green-400');
        promoMessage.classList.remove('bg-yellow-500', 'text-green-900');
    } else {
        promoMessage.textContent = 'Livraison gratuite dès 100€ d\'achat';
        promoMessage.classList.add('bg-yellow-500', 'text-green-900');
        promoMessage.classList.remove('text-yellow-900', 'bg-green-400');
    }
}

document.addEventListener('DOMContentLoaded', () => {
    // --- PANIER / PROMO ---
    const cartDrawer = document.getElementById('cart-drawer');
    const cartBtn = document.getElementById('cart-btn');
    const closeCartBtn = document.getElementById('close-cart');
    const applyPromoBtn = document.getElementById('apply-promo');
    const promoCodeInput = document.getElementById('promo-code');
    const checkoutBtn = document.getElementById('checkout-btn');

    if (cartBtn) {
        cartBtn.addEventListener('click', () => {
            cartDrawer.classList.remove('translate-x-full');
            document.body.classList.add('overflow-hidden');
            updatePromoMessage();
        });
    }

    if (closeCartBtn) {
        closeCartBtn.addEventListener('click', () => {
            cartDrawer.classList.add('translate-x-full');
            document.body.classList.remove('overflow-hidden');
        });
    }

    if (checkoutBtn) {
        checkoutBtn.addEventListener('click', () => {
            cartDrawer.classList.add('translate-x-full');
            document.body.classList.remove('overflow-hidden');
        });
    }

    // Gestion du code promo (visuel uniquement)
    if (applyPromoBtn) {
        applyPromoBtn.addEventListener('click', () => {
            if (promoCodeInput.value.trim().toUpperCase() === 'MAGIC2024') {
                promoApplied = true;
            } else {
                promoApplied = false;
            }
            updatePromoMessage();
        });
    }

    // --- CONNEXION / INSCRIPTION ---
    const loginForm = document.getElementById('login-form');
    const registerForm = document.getElementById('register-form');
    const tabLogin = document.getElementById('tab-login');
    const tabRegister = document.getElementById('tab-register');
    const authTitle = document.getElementById('auth-title');

    if (loginForm && registerForm && tabLogin && tabRegister) {
        const showLogin = () => {
            loginForm.classList.remove('hidden');
            registerForm.classList.add('hidden');
            tabLogin.classList.add('border-green-700', 'text-green-700');
            tabLogin.classList.remove('border-transparent', 'text-gray-500');
            tabRegister.classList.remove('border-green-700', 'text-green-700');
            tabRegister.classList.add('border-transparent', 'text-gray-500');
            authTitle.textContent = "Connexion des Aventuriers";
        };

        const showRegister = () => {
            loginForm.classList.add('hidden');
            registerForm.classList.remove('hidden');
            tabRegister.classList.add('border-green-700', 'text-green-700');
            tabRegister.classList.remove('border-transparent', 'text-gray-500');
            tabLogin.classList.remove('border-green-700', 'text-green-700');
            tabLogin.classList.add('border-transparent', 'text-gray-500');
            authTitle.textContent = "Création de Compte";
        };

        tabLogin.addEventListener('click', showLogin);
        tabRegister.addEventListener('click', showRegister);

        // Ouvre directement l'onglet création de compte si ?mode=register dans l'URL
        const params = new URLSearchParams(window.location.search);
        const mode = params.get("mode");
        if (mode === "register") {
        showRegister();
        } else {
        // ⚠️ Suppression des preventDefault : le formulaire enverra maintenant vers PHP
        showLogin();
        }
    }

    // --- CARROUSEL PRODUITS ---
    const relatedCarousel = document.getElementById('related-carousel');
    const prevButton = document.getElementById('related-prev');
    const nextButton = document.getElementById('related-next');

    if (relatedCarousel && prevButton && nextButton) {
        let carouselPosition = 0;
        const cardWidth = 272;
        const maxScroll = -(cardWidth * 1);

        nextButton.addEventListener('click', () => {
            carouselPosition = Math.max(carouselPosition - cardWidth, maxScroll);
            relatedCarousel.style.transform = `translateX(${carouselPosition}px)`;
        });

        prevButton.addEventListener('click', () => {
            carouselPosition = Math.min(carouselPosition + cardWidth, 0);
            relatedCarousel.style.transform = `translateX(${carouselPosition}px)`;
        });
    }

    updatePromoMessage();


});


function changeMainImage(src) {
    document.getElementById('main-image').src = src;
}
window.changeMainImage = changeMainImage;



document.addEventListener('DOMContentLoaded', () => {
    const pointsSelect = document.getElementById('pointsFideliteUtilises');
    const recapTotal = document.getElementById('summary-total');
    const finalPriceBtn = document.getElementById('final-price-btn');

    if (!pointsSelect || !recapTotal) return;

    // Sous-total côté PHP
    const sousTotal = parseFloat(
        document.getElementById('recap-commande-sousTotal')
            .textContent
            .replace(/\s/g, '')
            .replace(',', '.')
    );

    function calculerReduction(points) {
        switch(points) {
            case 10: return 5;
            case 20: return 10;
            case 50: return 25;
            default: return 0;
        }
    }

    pointsSelect.addEventListener('change', () => {
    const points = parseInt(pointsSelect.value.trim()) || 0;
    const reduction = calculerReduction(points);
    let total = sousTotal - reduction;
    if (total < 0) total = 0;

    const totalText = total.toFixed(2).replace('.', ',') + '€';
    recapTotal.textContent = totalText;

    if (finalPriceBtn) finalPriceBtn.textContent = totalText;
});
});
