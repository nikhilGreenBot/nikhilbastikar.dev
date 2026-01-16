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

    // Add a simple "back to top" functionality - Mac OS 8/9 style
    const backToTop = document.createElement('button');
    backToTop.innerHTML = '▲';
    backToTop.className = 'back-to-top';
    backToTop.style.cssText = `
        position: fixed;
        bottom: 20px;
        right: 20px;
        width: 28px;
        height: 28px;
        background: linear-gradient(to bottom, #e8e8e8 0%, #cccccc 50%, #999999 100%);
        color: #000000;
        border: 2px solid;
        border-color: #ffffff #404040 #404040 #ffffff;
        cursor: default;
        opacity: 0;
        transition: opacity 0.3s ease;
        z-index: 1000;
        font-size: 12px;
        font-weight: bold;
        box-shadow: 1px 1px 0 #808080;
        display: flex;
        align-items: center;
        justify-content: center;
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

    // Mac OS button hover effects
    backToTop.addEventListener('mouseenter', () => {
        backToTop.style.background = 'linear-gradient(to bottom, #cccccc 0%, #e8e8e8 50%, #cccccc 100%)';
    });
    backToTop.addEventListener('mouseleave', () => {
        backToTop.style.background = 'linear-gradient(to bottom, #e8e8e8 0%, #cccccc 50%, #999999 100%)';
    });
    backToTop.addEventListener('mousedown', () => {
        backToTop.style.background = 'linear-gradient(to bottom, #999999 0%, #cccccc 50%, #e8e8e8 100%)';
        backToTop.style.borderColor = '#404040 #ffffff #ffffff #404040';
    });
    backToTop.addEventListener('mouseup', () => {
        backToTop.style.background = 'linear-gradient(to bottom, #cccccc 0%, #e8e8e8 50%, #cccccc 100%)';
        backToTop.style.borderColor = '#ffffff #404040 #404040 #ffffff';
    });

    // Add some console love - Mac OS style
    console.log('Welcome to Macintosh!');
    console.log('Nikhil Bastikar\'s Personal Website');
    console.log('System 8.6 - © 1999 Apple Computer, Inc.');
}); 