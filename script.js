const navToggle = document.querySelector(".nav-toggle");
const siteNav = document.querySelector(".site-nav");
const navLinks = Array.from(document.querySelectorAll(".site-nav a"));
const sections = navLinks
  .map((link) => document.querySelector(link.getAttribute("href")))
  .filter(Boolean);

const setActiveNavLink = () => {
  if (!navLinks.length || !sections.length) {
    return;
  }

  const headerOffset = document.querySelector(".site-header")?.offsetHeight ?? 0;
  const activationLine = window.scrollY + headerOffset + 24;

  let activeSection = sections[0];

  sections.forEach((section) => {
    if (section.offsetTop <= activationLine) {
      activeSection = section;
    }
  });

  const activeId = `#${activeSection.id}`;

  navLinks.forEach((link) => {
    const isActive = link.getAttribute("href") === activeId;
    link.classList.toggle("is-active", isActive);
  });
};

if (navToggle && siteNav) {
  navToggle.addEventListener("click", () => {
    const isOpen = siteNav.classList.toggle("is-open");
    navToggle.setAttribute("aria-expanded", String(isOpen));
  });

  navLinks.forEach((link) => {
    link.addEventListener("click", () => {
      siteNav.classList.remove("is-open");
      navToggle.setAttribute("aria-expanded", "false");
    });
  });
}

if ("IntersectionObserver" in window) {
  setActiveNavLink();
  window.addEventListener("scroll", setActiveNavLink, { passive: true });
  window.addEventListener("resize", setActiveNavLink);

  const revealObserver = new IntersectionObserver(
    (entries, observer) => {
      entries.forEach((entry) => {
        if (!entry.isIntersecting) {
          return;
        }

        entry.target.classList.add("is-visible");
        observer.unobserve(entry.target);
      });
    },
    {
      rootMargin: "0px 0px -8% 0px",
      threshold: 0.12,
    }
  );

  document.querySelectorAll(".reveal").forEach((element) => {
    revealObserver.observe(element);
  });
} else {
  setActiveNavLink();
  window.addEventListener("scroll", setActiveNavLink, { passive: true });
  window.addEventListener("resize", setActiveNavLink);

  document.querySelectorAll(".reveal").forEach((element) => {
    element.classList.add("is-visible");
  });
}
