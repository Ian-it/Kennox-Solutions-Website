export type IconName =
  | 'sparkles'
  | 'megaphone'
  | 'cpu'
  | 'rocket';

export interface ServicePillar {
  id: string;
  number: string;
  title: string;
  short: string;
  description: string;
  detail: string[];
  icon: IconName;
}

export const services: ServicePillar[] = [
  {
    id: 'brand',
    number: '01',
    title: 'Brand',
    short: 'Strategy, Identity & Creative',
    description: 'From strategy to execution, we help businesses define their identity and communicate their value with clarity and impact.',
    detail: [
      'Brand Strategy — discovery, positioning, architecture',
      'Brand Identity — logos, visual systems, guidelines',
      'Creative Design — profiles, presentations, materials',
      'Brand Communication — messaging, copy, content strategy',
    ],
    icon: 'sparkles',
  },
  {
    id: 'marketing',
    number: '02',
    title: 'Marketing & Growth',
    short: 'Attention to Opportunity',
    description: 'The goal is not simply to gain attention. The goal is to create meaningful awareness, engagement, trust and growth.',
    detail: [
      'Marketing Strategy', 'Digital Marketing', 'Social Media Strategy', 'Content Marketing',
      'Campaign Development', 'Product Launches', 'Audience Growth', 'Go-to-Market Strategy',
      'Market Research', 'Business Development',
    ],
    icon: 'megaphone',
  },
  {
    id: 'technology',
    number: '03',
    title: 'Technology',
    short: 'Built Around Real Needs',
    description: 'We create digital solutions that solve real problems and create measurable value for businesses and their customers.',
    detail: [
      'Web Solutions — Corporate, E-commerce, Web Apps',
      'Mobile Applications — iOS, Android, Cross-platform',
      'Software — CRM, HR, Custom Business Systems',
      'Digital Transformation — Automation, Integration',
      'AI & Automation — Assistants, Workflows, Analytics',
    ],
    icon: 'cpu',
  },
  {
    id: 'innovations',
    number: '04',
    title: 'Innovations',
    short: 'Creating What Comes Next',
    description: 'We explore opportunities, develop ideas and build platforms designed to solve larger problems and transform industries.',
    detail: [
      'IDEA — Identify opportunities',
      'RESEARCH — Validate assumptions',
      'VALIDATION — Test and refine',
      'BUILD — Develop with precision',
      'LAUNCH — Introduce strategically',
      'SCALE — Grow continuously',
    ],
    icon: 'rocket',
  },
];

export const values = [
  { number: '01', title: 'Think Bold', text: 'Meaningful progress begins with the courage to think beyond what already exists.' },
  { number: '02', title: 'Create With Purpose', text: 'Everything we create should solve a problem, communicate clearly or create meaningful value.' },
  { number: '03', title: 'Stay Curious', text: 'We continuously learn, explore and ask what could be possible.' },
  { number: '04', title: 'Build Together', text: 'Great ideas become stronger through collaboration.' },
  { number: '05', title: 'Make It Matter', text: 'We focus on work that creates genuine impact.' },
  { number: '06', title: 'Keep Evolving', text: 'Businesses, technology and ideas must continue learning and evolving.' },
];

export const highlights = [
  { value: '04', label: 'connected capabilities under one roof' },
  { value: '06', label: 'beliefs that guide every project' },
  { value: '∞', label: 'ideas worth exploring next' },
];

export const differentiators = [
  'Strategy first, always',
  'Creative thinking with purpose',
  'Technology built for real problems',
  'One partner, connected capabilities',
];

export const whyKennox = [
  { title: 'Strategy First', text: 'We seek to understand before we create. Every project begins with deep discovery and strategic clarity.' },
  { title: 'Creative Thinking', text: 'We believe ordinary thinking rarely produces extraordinary outcomes. We push boundaries with purpose.' },
  { title: 'Technology With Purpose', text: 'We focus on technology that solves real problems and creates measurable value.' },
  { title: 'Built For The Future', text: 'We consider scalability, adaptability and long-term opportunity in everything we build.' },
  { title: 'Connected Capabilities', text: 'Brand, marketing, technology and innovation work together under one roof.' },
  { title: 'Partnership Mindset', text: 'We aim to understand the journey and become part of the solution, not just a vendor.' },
];

export const processSteps = [
  { number: '01', title: 'Discover', text: 'We listen, research and understand your business, audience and objectives.' },
  { number: '02', title: 'Strategize', text: 'We turn understanding into clear direction and actionable plans.' },
  { number: '03', title: 'Create', text: 'We bring the strategy to life through design, development and execution.' },
  { number: '04', title: 'Launch', text: 'We test, refine and prepare the solution for market introduction.' },
  { number: '05', title: 'Grow', text: 'We support, improve and scale the solution for long-term success.' },
];

export interface VentureStoryItem {
  label: string;
  text: string;
}

export interface Venture {
  id: string;
  name: string;
  tagline: string;
  eyebrow: string;
  nodes: string[];
  status: string;
  story: VentureStoryItem[];
}

export const ventures: Venture[] = [
  {
    id: 'doktaz-plaza',
    name: 'Doktaz Plaza',
    tagline: 'Healthcare Connected',
    eyebrow: 'A Healthcare Innovation by Kennox Solutions Ltd',
    nodes: ['Patients', 'Doctors', 'Hospitals', 'Pharmacies', 'Laboratories', 'Healthcare Services'],
    status: 'In Development',
    story: [
      { label: 'The Problem', text: 'Healthcare in Africa remains fragmented. Patients struggle to find providers, share records, or access consistent care across different facilities.' },
      { label: 'The Opportunity', text: 'What if healthcare worked as one connected ecosystem? What if a patient, a doctor, a hospital and a pharmacy could share information seamlessly?' },
      { label: 'The Idea', text: 'A unified healthcare technology platform that connects every stakeholder in the care journey — from patient to provider to pharmacy.' },
      { label: 'The Ecosystem', text: 'Patients, doctors, hospitals, pharmacies, laboratories and healthcare services — all connected through one intelligent platform.' },
    ],
  },
  {
    id: 'kennox-arena',
    name: 'Kennox Arena',
    tagline: 'Where Talent Meets Opportunity',
    eyebrow: 'Creative Industry Platform',
    nodes: ['Musicians', 'Artists', 'Creators', 'Audiences', 'Industry', 'Opportunities'],
    status: 'Concept / In Development',
    story: [
      { label: 'The Problem', text: 'African creative talent often lacks the infrastructure, connections and technology to reach global audiences and sustainable income.' },
      { label: 'The Opportunity', text: 'What if technology could bridge the gap between African creatives and the opportunities, audiences and industry stakeholders they need?' },
      { label: 'The Idea', text: 'A technology-powered platform that connects musicians, artists, creators and audiences in ways that create value for everyone.' },
      { label: 'The Ecosystem', text: 'Talent, audiences, opportunities and industry stakeholders — connected through technology to build a stronger creative economy.' },
    ],
  },
];

export interface ExplorationSector {
  id: string;
  title: string;
  text: string;
}

export const explorationSectors: ExplorationSector[] = [
  { id: 'healthcare', title: 'Healthcare', text: 'Building connected health ecosystems that bridge gaps between patients, providers and services. Doktaz Plaza is our first major exploration in this space.' },
  { id: 'creative', title: 'Creative Economy', text: 'Exploring how technology can unlock value for African artists, musicians and creators — and connect them to global markets.' },
  { id: 'music', title: 'Music', text: 'Reimagining how musicians connect with audiences, monetize their work and build sustainable careers through technology.' },
  { id: 'mobility', title: 'Mobility', text: 'Investigating how digital platforms can simplify movement, reduce friction and create smarter transport experiences.' },
  { id: 'transport', title: 'Transport', text: 'Exploring technology solutions that make logistics, delivery and personal transport more efficient and accessible.' },
  { id: 'tourism', title: 'Tourism', text: 'Thinking about how technology can transform travel experiences and connect African destinations with global travellers.' },
  { id: 'business', title: 'Business Services', text: 'Building digital tools and platforms that help African businesses operate more efficiently and compete globally.' },
  { id: 'commerce', title: 'Digital Commerce', text: 'Exploring new models for online trade, marketplaces and digital transactions that work for African markets.' },
  { id: 'futuretech', title: 'Future Technologies', text: 'Continuously exploring emerging technologies — AI, automation, blockchain, IoT — and their potential to transform African industries.' },
];

export interface InsightArticle {
  category: string;
  cardLabel: string;
  title: string;
  text: string;
  status: string;
}

export const insights: InsightArticle[] = [
  { category: 'Brand', cardLabel: 'The Future of African Brand Building', title: 'The Future of African Brand Building in a Digital-First World', text: 'How African companies can leverage digital transformation to build brands that compete globally while remaining authentically local.', status: 'Coming Soon' },
  { category: 'Technology', cardLabel: 'AI in Business Transformation', title: 'Practical AI: Moving Beyond Hype to Real Business Value', text: 'A framework for identifying, implementing and scaling AI solutions that deliver measurable outcomes for African enterprises.', status: 'Coming Soon' },
  { category: 'Innovation', cardLabel: 'Healthcare Innovation', title: 'Connecting Healthcare: The Case for Integrated Health Ecosystems', text: 'Why fragmented healthcare systems cost lives and money — and how technology can bridge the gap.', status: 'Coming Soon' },
  { category: 'Growth', cardLabel: 'Growth Strategies', title: 'From Attention to Action: Rethinking Marketing for African Markets', text: 'Why awareness metrics matter less than engagement depth — and how to build marketing that converts.', status: 'Coming Soon' },
  { category: 'Technology', cardLabel: 'Digital Transformation', title: 'The SME Digital Transformation Playbook', text: 'Practical steps for small and medium enterprises to digitize operations without enterprise-level budgets.', status: 'Coming Soon' },
  { category: 'Innovation', cardLabel: 'Creative Industries', title: 'Technology as Infrastructure for Creative Economies', text: 'How platforms can unlock value for artists, musicians and creators across the African continent.', status: 'Coming Soon' },
];

export interface CareerTrack {
  id: string;
  title: string;
  text: string;
  cta: string;
}

export const careerTracks: CareerTrack[] = [
  { id: 'openings', title: 'Join the Team', text: 'Explore available opportunities to work with us on challenging projects that make a real difference.', cta: 'View Openings' },
  { id: 'talent-network', title: 'Our Talent Network', text: 'Developers, designers, marketers, creatives, consultants and industry specialists can submit their profiles.', cta: 'Submit Profile' },
  { id: 'future-builders', title: 'Future Builders', text: 'Future internships, graduate opportunities and young talent programmes for the next generation.', cta: 'Learn More' },
];

export interface Testimonial {
  quote: string;
  name: string;
  role: string;
}

// Placeholder quotes — swap these for real client testimonials when available.
export const testimonials: Testimonial[] = [
  { quote: 'Kennox took a rough idea and treated it like it already mattered. That changed how fast we were able to move.', name: 'Amina W.', role: 'Founder, health-tech startup' },
  { quote: "They didn't just design us a logo — they helped us figure out what we were actually trying to say.", name: 'Brian O.', role: 'Marketing Lead, retail brand' },
  { quote: 'The kind of technology partner who asks why before they ask what. That is rarer than it should be.', name: 'Faith N.', role: 'Operations Director' },
];

export const navItems = [
  { href: '/', label: 'Home' },
  { href: '/about', label: 'About' },
  { href: '/services', label: 'What We Do' },
  { href: '/innovation-lab', label: 'Innovation Lab' },
  { href: '/insights', label: 'Insights' },
  { href: '/careers', label: 'Careers' },
  { href: '/contact', label: 'Contact' },
];

export const contactInfo = {
  email: 'info@kennox.co.ke',
  phone: '+254 727 321 145',
  location: 'Eldoret, Kenya',
  locationNote: 'Building for Africa.',
  hours: 'Monday — Friday, 9:00 AM — 6:00 PM EAT',
};

export const contactInterests = [
  { value: 'branding', label: 'Branding' },
  { value: 'marketing', label: 'Marketing & Growth' },
  { value: 'website', label: 'Website Development' },
  { value: 'mobile', label: 'Mobile App' },
  { value: 'software', label: 'Software Development' },
  { value: 'digital', label: 'Digital Transformation' },
  { value: 'ai', label: 'AI & Automation' },
  { value: 'innovation', label: 'Innovation / Partnership' },
  { value: 'other', label: 'Other' },
];

export const footerServiceLinks = [
  { label: 'Brand', href: '/services' },
  { label: 'Marketing & Growth', href: '/services' },
  { label: 'Technology', href: '/services' },
  { label: 'Digital Transformation', href: '/services' },
  { label: 'Innovations', href: '/services' },
];

export const footerVentureLinks = [
  { label: 'Doktaz Plaza', href: '/innovation-lab#doktaz-plaza' },
  { label: 'Kennox Arena', href: '/innovation-lab#kennox-arena' },
  { label: 'Innovation Pipeline', href: '/innovation-lab#innovation-pipeline' },
];

// Placeholder URLs — swap in the real handles when available.
export const socialLinks = [
  { label: 'LinkedIn', icon: 'linkedin', href: '#' },
  { label: 'Facebook', icon: 'facebook', href: '#' },
  { label: 'Instagram', icon: 'instagram', href: '#' },
  { label: 'X', icon: 'x', href: '#' },
  { label: 'YouTube', icon: 'youtube', href: '#' },
];
