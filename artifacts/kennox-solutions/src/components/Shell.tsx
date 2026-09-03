import { ArrowUpRight, Facebook, Instagram, Linkedin, Menu, Twitter, X, Youtube } from 'lucide-react';
import { type ReactNode, useEffect, useState } from 'react';
import { Link, useLocation } from 'wouter';
import { contactInfo, footerServiceLinks, footerVentureLinks, navItems, socialLinks } from '@/data/site';
import { SupportTools } from '@/components/SupportTools';

const socialIconMap = { linkedin: Linkedin, facebook: Facebook, instagram: Instagram, x: Twitter, youtube: Youtube };

export function Logo({ light = false, full = false, className = '' }: { light?: boolean; full?: boolean; className?: string }) {
  const src = full
    ? (light ? '/logo-light.png' : '/logo.png')
    : (light ? '/logo-light-mark.png' : '/logo-mark.png');
  return <Link href="/" className={`group inline-flex items-center transition-transform hover:scale-[1.02] ${className}`} data-testid="link-logo">
    <img src={src} alt="Kennox Solutions" className={full ? 'h-16 w-auto sm:h-[4.75rem]' : 'h-9 w-auto sm:h-10'} />
  </Link>;
}

export function Header() {
  const [open, setOpen] = useState(false);
  const [location] = useLocation();
  useEffect(() => {
    const pageTitles: Record<string, string> = {
      '/': 'Kennox Solutions Ltd — Brand · Technology · Innovations',
      '/about': 'About Kennox | Kennox Solutions Ltd',
      '/services': 'What We Do | Kennox Solutions Ltd',
      '/innovation-lab': 'Innovation Lab | Kennox Solutions Ltd',
      '/insights': 'Insights | Kennox Solutions Ltd',
      '/careers': 'Careers | Kennox Solutions Ltd',
      '/contact': 'Contact | Kennox Solutions Ltd',
    };
    const pageDescriptions: Record<string, string> = {
      '/': 'A forward-thinking African company combining strategy, creativity and technology to build powerful brands, intelligent digital solutions and innovative platforms.',
      '/about': 'Kennox Solutions Ltd is built on ideas and driven by possibility — operating at the intersection of branding, technology and innovation.',
      '/services': 'Explore brand strategy, marketing & growth, technology, and innovation services from Kennox Solutions Ltd.',
      '/innovation-lab': 'This is how Kennox thinks. Explore Doktaz Plaza, Kennox Arena, and the sectors we are actively exploring next.',
      '/insights': 'Thought leadership from Kennox Solutions Ltd on brand, technology, growth, and innovation in Africa.',
      '/careers': 'Join Kennox Solutions Ltd and be part of a team that transforms possibilities into meaningful solutions.',
      '/contact': 'Get in touch with Kennox Solutions Ltd in Eldoret, Kenya. Let’s start a conversation about your next project.',
    };
    document.title = pageTitles[location] ?? 'Kennox Solutions';
    let description = document.querySelector('meta[name="description"]');
    if (!description) {
      description = document.createElement('meta');
      description.setAttribute('name', 'description');
      document.head.appendChild(description);
    }
    description.setAttribute('content', pageDescriptions[location] ?? pageDescriptions['/']);
  }, [location]);
  return <header className="fixed inset-x-0 top-0 z-40 border-b border-[hsl(var(--border)/.75)] bg-[hsl(var(--background)/.92)] backdrop-blur-md">
    <div className="page-wrap flex h-[76px] items-center justify-between">
      <Logo />
      <nav className="hidden items-center gap-8 md:flex" aria-label="Main navigation">
        {navItems.map((item) => <Link key={item.href} href={item.href} data-testid={`link-nav-${item.label.toLowerCase().replaceAll(' ', '-')}`} className={`relative py-2 text-[.73rem] font-semibold uppercase tracking-[.12em] transition-colors hover:text-[hsl(var(--accent))] ${location === item.href ? 'text-[hsl(var(--accent))]' : 'text-[hsl(var(--muted-foreground))]'}`}>{item.label}{location === item.href && <span className="absolute -bottom-1 left-0 h-px w-full bg-[hsl(var(--secondary))]" />}</Link>)}
      </nav>
      <div className="hidden items-center gap-5 md:flex">
        <Link href="/contact" className="group inline-flex items-center gap-2 rounded-full bg-[hsl(var(--primary))] px-5 py-3 text-[.7rem] font-bold uppercase tracking-[.1em] text-[hsl(var(--primary-foreground))] transition-transform hover:-translate-y-0.5" data-testid="link-header-start">Start a Project <ArrowUpRight size={14} className="transition-transform group-hover:translate-x-0.5 group-hover:-translate-y-0.5" /></Link>
      </div>
      <button type="button" className="grid h-11 w-11 place-items-center rounded-full border border-[hsl(var(--border))] md:hidden" aria-label={open ? 'Close menu' : 'Open menu'} onClick={() => setOpen(!open)} data-testid="button-mobile-menu">{open ? <X size={19} /> : <Menu size={19} />}</button>
    </div>
    {open && <div className="border-t border-[hsl(var(--border))] bg-[hsl(var(--background))] px-4 py-5 md:hidden">
      <nav className="page-wrap flex flex-col gap-1" aria-label="Mobile navigation">
        {navItems.map((item) => <Link key={item.href} href={item.href} onClick={() => setOpen(false)} className="border-b border-[hsl(var(--border)/.7)] py-4 text-lg font-semibold text-[hsl(var(--primary))]" data-testid={`link-mobile-${item.label.toLowerCase().replaceAll(' ', '-')}`}>{item.label}</Link>)}
        <Link href="/contact" onClick={() => setOpen(false)} className="mt-2 inline-flex w-fit items-center gap-2 rounded-full bg-[hsl(var(--secondary))] px-5 py-3 text-xs font-bold uppercase tracking-widest text-[hsl(var(--primary))]" data-testid="link-mobile-start">Start a Project <ArrowUpRight size={15} /></Link>
      </nav>
    </div>}
  </header>;
}

export function Footer() {
  return <footer className="bg-[hsl(var(--primary))] text-[hsl(var(--primary-foreground))]">
    <div className="page-wrap grid gap-12 py-16 md:grid-cols-[1.1fr_.6fr_.6fr_.6fr] md:py-20">
      <div>
        <Logo light full />
        <p className="mt-7 max-w-sm text-lg leading-relaxed text-[hsl(var(--primary-foreground)/.72)]">A forward-thinking African company combining strategy, creativity and technology to build powerful brands, intelligent digital solutions and innovative platforms.</p>
        <Link href="/contact" className="mt-7 inline-flex items-center gap-2 border-b border-[hsl(var(--secondary))] pb-2 text-sm font-semibold text-[hsl(var(--secondary))]" data-testid="link-footer-talk">Start a Project <ArrowUpRight size={15} /></Link>
        <div className="mt-7 flex items-center gap-3">
          {socialLinks.map((social) => {
            const Icon = socialIconMap[social.icon as keyof typeof socialIconMap];
            return (
              <a
                key={social.label}
                href={social.href}
                target="_blank"
                rel="noreferrer"
                aria-label={social.label}
                className="grid h-9 w-9 place-items-center rounded-full border border-[hsl(var(--primary-foreground)/.3)] transition-colors hover:border-[hsl(var(--secondary))] hover:text-[hsl(var(--secondary))]"
                data-testid={`link-footer-social-${social.label.toLowerCase()}`}
              >
                <Icon size={15} />
              </a>
            );
          })}
        </div>
      </div>
      <div><p className="eyebrow text-[hsl(var(--secondary))]">Explore</p><div className="mt-5 flex flex-col gap-3">{navItems.map((item) => <Link key={item.href} href={item.href} className="w-fit text-sm text-[hsl(var(--primary-foreground)/.72)] transition-colors hover:text-[hsl(var(--secondary))]" data-testid={`link-footer-${item.label.toLowerCase().replaceAll(' ', '-')}`}>{item.label}</Link>)}</div></div>
      <div><p className="eyebrow text-[hsl(var(--secondary))]">Services</p><div className="mt-5 flex flex-col gap-3">{footerServiceLinks.map((item) => <Link key={item.label} href={item.href} className="w-fit text-sm text-[hsl(var(--primary-foreground)/.72)] transition-colors hover:text-[hsl(var(--secondary))]" data-testid={`link-footer-service-${item.label.toLowerCase().replaceAll(' ', '-')}`}>{item.label}</Link>)}</div></div>
      <div>
        <p className="eyebrow text-[hsl(var(--secondary))]">Ventures</p>
        <div className="mt-5 flex flex-col gap-3">{footerVentureLinks.map((item) => <Link key={item.label} href={item.href} className="w-fit text-sm text-[hsl(var(--primary-foreground)/.72)] transition-colors hover:text-[hsl(var(--secondary))]" data-testid={`link-footer-venture-${item.label.toLowerCase().replaceAll(' ', '-')}`}>{item.label}</Link>)}</div>
        <p className="eyebrow mt-7 text-[hsl(var(--secondary))]">Say hello</p>
        <a href={`mailto:${contactInfo.email}`} className="mt-5 block text-sm text-[hsl(var(--primary-foreground)/.72)] hover:text-[hsl(var(--secondary))]" data-testid="link-footer-email">{contactInfo.email}</a>
        <a href={`tel:${contactInfo.phone.replace(/\s+/g, '')}`} className="mt-2 block text-sm text-[hsl(var(--primary-foreground)/.72)] hover:text-[hsl(var(--secondary))]" data-testid="link-footer-phone">{contactInfo.phone}</a>
        <p className="mt-3 text-sm text-[hsl(var(--primary-foreground)/.5)]">Kenya · Building for Africa.</p>
      </div>
    </div>
    <div className="page-wrap flex flex-col items-center gap-3 border-t border-[hsl(var(--primary-foreground)/.15)] py-5 text-[.67rem] uppercase tracking-[.13em] text-[hsl(var(--primary-foreground)/.45)] sm:flex-row sm:justify-between">
      <span>© {new Date().getFullYear()} Kennox Solutions Ltd</span>
      <a
        href="https://softrixafrica.vercel.app"
        target="_blank"
        rel="noreferrer"
        className="inline-flex items-center gap-1 transition-colors hover:text-[hsl(var(--secondary))]"
        data-testid="link-footer-powered-by"
      >
        Powered by Softrix Africa <ArrowUpRight size={12} />
      </a>
      <span>Brand · Technology · Innovations</span>
    </div>
  </footer>;
}

export function Shell({ children }: { children: ReactNode }) {
  return <div className="grain min-h-[100dvh]"><Header /><main className="pt-[76px]">{children}</main><Footer /><SupportTools /></div>;
}
