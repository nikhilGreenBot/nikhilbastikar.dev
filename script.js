// Simple JavaScript for Panda's Blog

document.addEventListener('DOMContentLoaded', function() {
    // Add smooth scrolling / cross-fade for navigation links
    const navLinks = document.querySelectorAll('.nav-links a');
    
    navLinks.forEach(link => {
        link.addEventListener('click', function(e) {
            const href = this.getAttribute('href');
            // Handle internal anchors
            if (href.startsWith('#')) {
                e.preventDefault();
                const targetId = href.substring(1);
                const targetElement = document.getElementById(targetId);
                
                if (targetElement) {
                    targetElement.scrollIntoView({
                        behavior: 'smooth'
                    });
                }
            } else if (this.classList.contains('nav-photography')) {
                // Cross-fade transition to photography page
                e.preventDefault();
                document.body.style.transition = 'opacity 300ms ease';
                document.body.style.opacity = '0';
                setTimeout(() => { window.location.href = href; }, 280);
            }
        });
    });

    // Add active class to current navigation item
    function setActiveNavItem() {
        const currentPath = window.location.pathname;
        navLinks.forEach(link => {
            link.classList.remove('active');
            if (link.getAttribute('href') === currentPath || 
                (currentPath === '/' && link.getAttribute('href') === '#home')) {
                link.classList.add('active');
            }
        });
    }

    setActiveNavItem();

    // Add some subtle animations
    const posts = document.querySelectorAll('.post');
    posts.forEach((post, index) => {
        post.style.opacity = '0';
        post.style.transform = 'translateY(20px)';
        
        setTimeout(() => {
            post.style.transition = 'opacity 0.6s ease, transform 0.6s ease';
            post.style.opacity = '1';
            post.style.transform = 'translateY(0)';
        }, index * 100);
    });

    // Add a simple theme toggle (you can expand this later)
    const prefersDark = window.matchMedia('(prefers-color-scheme: dark)');
    
    function updateTheme() {
        if (prefersDark.matches) {
            document.body.classList.add('dark-mode');
        } else {
            document.body.classList.remove('dark-mode');
        }
    }

    prefersDark.addListener(updateTheme);
    updateTheme();

    // Add a simple "back to top" functionality
    const backToTop = document.createElement('button');
    backToTop.innerHTML = '↑';
    backToTop.className = 'back-to-top';
    backToTop.style.cssText = `
        position: fixed;
        bottom: 20px;
        right: 20px;
        width: 40px;
        height: 40px;
        border-radius: 50%;
        background: #333;
        color: white;
        border: none;
        cursor: pointer;
        opacity: 0;
        transition: opacity 0.3s ease;
        z-index: 1000;
        font-size: 18px;
    `;

    document.body.appendChild(backToTop);

    window.addEventListener('scroll', () => {
        if (window.scrollY > 300) {
            backToTop.style.opacity = '1';
        } else {
            backToTop.style.opacity = '0';
        }
    });

    backToTop.addEventListener('click', () => {
        window.scrollTo({
            top: 0,
            behavior: 'smooth'
        });
    });

    // Add some console love
    console.log('🐼 Welcome to Panda\'s Blog!');
    console.log('Thanks for visiting!');
}); 