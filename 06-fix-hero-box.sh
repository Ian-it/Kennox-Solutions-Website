#!/usr/bin/env bash
set -euo pipefail

# 06-fix-hero-box.sh
# Kennox Solutions rebrand — hero box + marquee fix, revision 2.
#
# What changed from the first version:
# - The marquee's rounded bottom corner is now forced directly on the
#   marquee element itself (rounded-b-[1.75rem]) instead of relying only
#   on the parent card's overflow-hidden clipping, which was rendering
#   with square corners.
# - Headline, panel, and spacing sizes trimmed further so the whole card
#   (header + hero + marquee) totals ~512px, comfortably inside real
#   desktop viewports with margin to spare on smaller screens too.
#
# Only touches the Home page hero — no other page is affected.
# Run this from the ROOT of your project-source checkout, same as 01-05.

echo "==> Fixing Home hero layout (revision 2)..."

mkdir -p "$(dirname "artifacts/kennox-solutions/src/pages/Pages.tsx")"
cat > "artifacts/kennox-solutions/src/pages/Pages.tsx" << 'KENNOX_96B075EA66'
import {
  ArrowDown,
  ArrowUpRight,
  Mail,
} from "lucide-react";
import { type ReactNode, useState } from "react";
import { Link } from "wouter";
import {
  ArtPanel,
  KennoxMarquee,
  SectionIntro,
  ServiceExplorer,
  TestimonialSlideshow,
  accentFor,
} from "@/components/Marketing";
import { Reveal } from "@/components/Reveal";
import { ConversationOptions } from "@/components/SupportTools";
import {
  careerTracks,
  contactInfo,
  contactInterests,
  explorationSectors,
  highlights,
  insights,
  processSteps,
  ventures,
  values,
  whyKennox,
} from "@/data/site";
import { submitContact, type ContactSubmission } from "@/services/submissions";

function CTA({
  href,
  children,
  dark = false,
}: {
  href: string;
  children: ReactNode;
  dark?: boolean;
}) {
  return (
    <Link
      href={href}
      className={`group inline-flex items-center gap-2 rounded-full px-6 py-3.5 text-[.7rem] font-bold uppercase tracking-[.12em] transition-transform hover:-translate-y-0.5 ${dark ? "bg-[hsl(var(--secondary))] text-[hsl(var(--primary))]" : "bg-[hsl(var(--primary))] text-[hsl(var(--primary-foreground))]"}`}
      data-testid={`link-cta-${href.replace("/", "") || "home"}`}
    >
      {children}
      <ArrowUpRight
        size={15}
        className="transition-transform group-hover:translate-x-0.5 group-hover:-translate-y-0.5"
      />
    </Link>
  );
}

export function Home() {
  return (
    <>
      <section className="page-wrap pb-4 pt-4 sm:pt-5">
        <div className="overflow-hidden rounded-[1.75rem] border border-[hsl(var(--border))] bg-[hsl(var(--background))] shadow-[var(--shadow-md)]">
          <div className="grid gap-6 p-5 sm:gap-8 sm:p-7 lg:grid-cols-[1.02fr_.98fr] lg:items-center lg:gap-12">
            <div className="reveal">
              <p className="eyebrow flex items-center gap-3 text-[hsl(var(--accent))]">
                <span className="h-px w-8 bg-[hsl(var(--secondary))]" />
                For businesses with something worth building
              </p>
              <h1 className="serif mt-3 max-w-lg text-3xl leading-[1.05] tracking-[-.03em] sm:text-4xl md:text-5xl lg:text-[2.85rem]">
                Building <em className="text-[hsl(var(--accent))]">Brands</em>.
                <br />
                Powering <em className="text-[hsl(var(--accent))]">Ideas</em>.
                <br />
                Creating the <em className="text-[hsl(var(--accent))]">Future</em>.
              </h1>
              <p className="mt-4 max-w-md text-sm leading-relaxed text-[hsl(var(--muted-foreground))] sm:text-base">
                You've got the vision. We bring the strategy, the craft and the
                technology to help it travel — from a rough idea to something
                people actually use, trust and remember.
              </p>
              <div className="mt-5 flex flex-wrap gap-3">
                <CTA href="/contact">Start a Project</CTA>
                <Link
                  href="/services"
                  className="inline-flex items-center gap-2 rounded-full border border-[hsl(var(--border))] px-6 py-3.5 text-[.7rem] font-bold uppercase tracking-[.12em] hover:border-[hsl(var(--primary))]"
                  data-testid="link-hero-fit"
                >
                  See What We Do <ArrowDown size={15} />
                </Link>
              </div>
            </div>
            <div className="reveal reveal-delay-2">
              <ArtPanel />
            </div>
          </div>
          <KennoxMarquee className="rounded-b-[1.75rem]" />
        </div>
      </section>

      <section className="page-wrap grid gap-12 py-20 sm:py-28 lg:grid-cols-[.7fr_1.3fr]">
        <SectionIntro
          eyebrow="Who We Are"
          title={
            <>
              We build more than{" "}
              <em className="text-[hsl(var(--accent))]">solutions.</em>
            </>
          }
        />
        <div className="lg:pt-16">
          <Reveal>
            <p className="max-w-xl text-xl leading-relaxed text-[hsl(var(--muted-foreground))]">
              Good ideas are everywhere — yours included. What separates a
              good idea from a great outcome is the follow-through: the
              strategy, the craft, and people willing to sit with the hard
              questions until the answer is obvious. That's where we come in.
              We're driven by creativity, technology and the belief that
              great ideas can create real change.
            </p>
          </Reveal>
          <div className="mt-14 grid gap-8 border-t border-[hsl(var(--border))] pt-7 sm:grid-cols-3">
            {highlights.map((highlight, index) => (
              <Reveal key={highlight.label} organic delay={index * 0.08}>
                <p className="serif text-5xl text-[hsl(var(--primary))]">
                  {highlight.value}
                </p>
                <p className="mt-2 max-w-[150px] text-sm leading-snug text-[hsl(var(--muted-foreground))]">
                  {highlight.label}
                </p>
              </Reveal>
            ))}
          </div>
        </div>
      </section>
      <section className="bg-[hsl(var(--primary))] py-20 text-[hsl(var(--primary-foreground))] sm:py-28">
        <div className="page-wrap">
          <div className="flex flex-col justify-between gap-8 sm:flex-row sm:items-end">
            <SectionIntro
              dark
              eyebrow="What we do"
              title={
                <>
                  How your idea
                  <br />
                  becomes <em>impact.</em>
                </>
              }
            >
              Pick a lane or explore all four — brand, growth, technology and
              innovation all live under one roof here.
            </SectionIntro>
            <CTA href="/services" dark>
              Explore the work
            </CTA>
          </div>
          <div className="mt-14">
            <ServiceExplorer limit={3} />
          </div>
        </div>
      </section>
      <section className="page-wrap py-20 sm:py-28">
        <SectionIntro eyebrow="Beyond Services" title="This is how we think." >
          Not just what we build — but why we build it. Some of what's below
          is already taking shape. Some of it is still just a question we
          can't stop asking.
        </SectionIntro>
        <div className="mt-12 grid gap-6 sm:grid-cols-2">
          {ventures.map((venture, index) => {
            const accent = accentFor(index);
            return (
              <Reveal
                key={venture.id}
                organic
                delay={index * 0.08}
                className="flex flex-col overflow-hidden rounded-[1.75rem] border border-[hsl(var(--border))]"
              >
                <div className={`flex min-h-[7rem] items-center p-6 ${accent.bg}`}>
                  <p className="serif text-2xl leading-tight text-[hsl(var(--primary-foreground))]">{venture.name}</p>
                </div>
                <div className="p-8">
                  <p className="eyebrow text-[hsl(var(--accent))]">{venture.eyebrow}</p>
                  <p className="mt-2 text-sm font-semibold text-[hsl(var(--muted-foreground))]">{venture.tagline}</p>
                  <p className="mt-4 text-sm leading-relaxed text-[hsl(var(--muted-foreground))]">{venture.story[2]?.text}</p>
                </div>
              </Reveal>
            );
          })}
        </div>
        <div className="mt-10">
          <CTA href="/innovation-lab">Explore the Innovation Lab</CTA>
        </div>
      </section>
      <section className="page-wrap py-20 sm:py-28">
        <SectionIntro eyebrow="Words From The Room" title="We don't just talk about the work." >
          Here's what it sounds like from the other side of the table.
        </SectionIntro>
        <div className="mt-10">
          <TestimonialSlideshow />
        </div>
      </section>
      <section className="page-wrap pb-20 sm:pb-28">
        <Reveal className="relative overflow-hidden rounded-[2rem] bg-[hsl(var(--secondary))] px-7 py-14 sm:px-14 md:py-20">
          <div className="absolute -right-8 -top-24 h-72 w-72 rounded-full border-[34px] border-[hsl(var(--primary)/.12)]" />
          <div className="relative max-w-2xl">
            <p className="eyebrow text-[hsl(var(--accent))]">
              Have an idea worth building?
            </p>
            <h2 className="serif mt-4 text-4xl leading-tight tracking-[-.03em] sm:text-6xl">
              Let's talk it through. No pitch deck required.
            </h2>
            <div className="mt-8">
              <CTA href="/contact">Start a Project</CTA>
            </div>
          </div>
        </Reveal>
      </section>
    </>
  );
}

export function About() {
  return (
    <>
      <section className="page-wrap grid gap-10 pb-20 pt-16 sm:pt-24 lg:grid-cols-[1.1fr_.9fr] lg:items-end">
        <div className="reveal">
          <p className="eyebrow text-[hsl(var(--accent))]">Our Story</p>
          <h1 className="serif mt-5 max-w-3xl text-5xl leading-[1.02] tracking-[-.05em] sm:text-7xl">
            We started with a simple{" "}
            <em className="text-[hsl(var(--accent))]">question.</em>
          </h1>
        </div>
        <p className="max-w-sm text-lg leading-relaxed text-[hsl(var(--muted-foreground))]">
          What if a good idea never had to stay just an idea? Kennox sits at
          the intersection of branding, technology and innovation — because
          most real problems don't respect neat categories, and neither do
          we.
        </p>
      </section>
      <section className="page-wrap">
        <ArtPanel compact />
      </section>
      <section className="page-wrap grid gap-8 py-20 sm:py-28 md:grid-cols-3">
        {[
          {
            title: "Our Purpose",
            body: (
              <>
                <strong className="text-[hsl(var(--accent))]">
                  Turning Ideas Into Meaningful Solutions.
                </strong>
                <br />
                <br />
                Great ideas are everywhere. But an idea only becomes valuable
                once someone develops it, refines it, communicates it
                clearly, and turns it into something people can actually
                use, experience and believe in. That's the gap we exist to
                close.
              </>
            ),
          },
          {
            title: "Our Vision",
            body: "To become a leading African company shaping the future through brand, technology and innovation — the kind of company others point to when they talk about what's possible here.",
          },
          {
            title: "Our Mission",
            body: "To combine strategy, creativity and technology to build meaningful brands, intelligent digital solutions and innovative platforms that solve problems people actually have.",
          },
        ].map((card, index) => {
          const accent = accentFor(index);
          return (
            <Reveal
              key={card.title}
              organic
              delay={index * 0.08}
              className="flex flex-col overflow-hidden rounded-[1.5rem] border border-[hsl(var(--border))]"
            >
              <div className={`flex min-h-[5.5rem] items-center p-6 ${accent.bg}`}>
                <h3 className="serif text-2xl text-[hsl(var(--primary-foreground))]">{card.title}</h3>
              </div>
              <p className="p-8 text-sm leading-relaxed text-[hsl(var(--muted-foreground))]">{card.body}</p>
            </Reveal>
          );
        })}
      </section>
      <section className="bg-[hsl(var(--muted))] py-20 sm:py-28">
        <div className="page-wrap">
          <SectionIntro eyebrow="Our Culture" title="How we show up, every time." />
          <div className="mt-12 grid gap-6 md:grid-cols-3">
            {values.map((value, index) => {
              const accent = accentFor(index);
              return (
                <Reveal
                  key={value.number}
                  organic
                  delay={index * 0.06}
                  className="flex flex-col overflow-hidden rounded-[1.5rem] border border-[hsl(var(--border))] bg-[hsl(var(--background))]"
                >
                  <div className={`flex min-h-[4.5rem] items-center justify-between p-6 ${accent.bg}`}>
                    <h3 className="serif text-xl text-[hsl(var(--primary-foreground))]">{value.title}</h3>
                    <span className="serif text-lg text-[hsl(var(--primary-foreground)/.6)]">{value.number}</span>
                  </div>
                  <p className="p-6 text-sm leading-relaxed text-[hsl(var(--muted-foreground))]">
                    {value.text}
                  </p>
                </Reveal>
              );
            })}
          </div>
        </div>
      </section>
      <section className="page-wrap py-20 text-center sm:py-28">
        <Reveal><p className="eyebrow text-[hsl(var(--accent))]">Let's build together</p></Reveal>
        <Reveal delay={0.08}>
          <h2 className="serif mx-auto mt-5 max-w-2xl text-4xl leading-tight sm:text-6xl">
            There's room for your next idea here.
          </h2>
        </Reveal>
        <Reveal delay={0.16}>
          <p className="mx-auto mt-4 max-w-md text-sm text-[hsl(var(--muted-foreground))]">
            Bring it as it is — half-formed is a perfectly good place to
            start.
          </p>
        </Reveal>
        <Reveal delay={0.22}>
          <div className="mt-8">
            <CTA href="/contact">Start a Project</CTA>
          </div>
        </Reveal>
      </section>
    </>
  );
}

export function Services() {
  return (
    <>
      <section className="page-wrap pb-16 pt-16 sm:pb-24 sm:pt-24">
        <div className="reveal">
          <p className="eyebrow text-[hsl(var(--accent))]">What We Do</p>
          <h1 className="serif mt-5 max-w-4xl text-5xl leading-[1.02] tracking-[-.05em] sm:text-7xl">
            Support for every part{" "}
            <em className="text-[hsl(var(--accent))]">of the build.</em>
          </h1>
          <p className="mt-7 max-w-xl text-lg leading-relaxed text-[hsl(var(--muted-foreground))]">
            Pick one door or walk through all of them — brand, growth,
            technology, innovation. Wherever you're starting from, there's a
            place to begin.
          </p>
        </div>
      </section>
      <section className="bg-[hsl(var(--primary))] py-20 text-[hsl(var(--primary-foreground))] sm:py-28">
        <div className="page-wrap">
          <ServiceExplorer />
        </div>
      </section>
      <section className="page-wrap py-20 sm:py-28">
        <SectionIntro eyebrow="The Kennox Difference" title="One partner. Connected thinking.">
          You shouldn't have to juggle five different agencies to get one
          coherent brand. Here's why that matters to us.
        </SectionIntro>
        <div className="mt-12 grid gap-6 md:grid-cols-3">
          {whyKennox.map((item, index) => {
            const accent = accentFor(index);
            return (
              <Reveal
                key={item.title}
                organic
                delay={index * 0.06}
                className="flex flex-col overflow-hidden rounded-[1.5rem] border border-[hsl(var(--border))]"
              >
                <div className={`flex min-h-[4.5rem] items-center p-6 ${accent.bg}`}>
                  <h3 className="serif text-xl text-[hsl(var(--primary-foreground))]">{item.title}</h3>
                </div>
                <p className="p-6 text-sm leading-relaxed text-[hsl(var(--muted-foreground))]">
                  {item.text}
                </p>
              </Reveal>
            );
          })}
        </div>
      </section>
      <section className="bg-[hsl(var(--muted))] py-20 sm:py-28">
        <div className="page-wrap">
          <SectionIntro eyebrow="How We Work" title="Our process, in five honest steps.">
            From the first real conversation to the moment your idea is out
            in the world — and beyond.
          </SectionIntro>
          <div className="mt-12 grid gap-6 sm:grid-cols-2 lg:grid-cols-5">
            {processSteps.map((step, index) => {
              const accent = accentFor(index);
              return (
                <Reveal
                  key={step.number}
                  organic
                  delay={index * 0.06}
                  className="flex flex-col overflow-hidden rounded-[1.5rem] border border-[hsl(var(--border))] bg-[hsl(var(--background))]"
                >
                  <div className={`flex min-h-[3.75rem] items-center justify-between p-5 ${accent.bg}`}>
                    <h3 className="serif text-lg text-[hsl(var(--primary-foreground))]">{step.title}</h3>
                    <span className="serif text-base text-[hsl(var(--primary-foreground)/.6)]">{step.number}</span>
                  </div>
                  <p className="p-5 text-sm leading-relaxed text-[hsl(var(--muted-foreground))]">{step.text}</p>
                </Reveal>
              );
            })}
          </div>
        </div>
      </section>
      <section className="page-wrap py-20 sm:py-28">
        <Reveal className="grid gap-8 rounded-[2rem] border border-[hsl(var(--border))] p-8 sm:p-12 md:grid-cols-[1fr_auto] md:items-center">
          <div>
            <p className="eyebrow text-[hsl(var(--accent))]">
              Not sure where to begin?
            </p>
            <h2 className="serif mt-4 text-4xl">
              That's a completely normal place to start.
            </h2>
          </div>
          <CTA href="/contact">Let's Figure It Out</CTA>
        </Reveal>
      </section>
    </>
  );
}

export function InnovationLab() {
  return (
    <>
      <section className="page-wrap grid gap-10 pb-16 pt-16 sm:pb-24 sm:pt-24 lg:grid-cols-[.9fr_1.1fr] lg:items-end">
        <div className="reveal">
          <p className="eyebrow text-[hsl(var(--accent))]">Beyond Services</p>
          <h1 className="serif mt-5 text-5xl leading-[1.02] tracking-[-.05em] sm:text-7xl">
            Innovation <em className="text-[hsl(var(--accent))]">Lab.</em>
          </h1>
        </div>
        <p className="reveal reveal-delay-2 max-w-sm text-lg leading-relaxed text-[hsl(var(--muted-foreground))]">
          Not just what we build — why we build it. Some of what's below is
          already taking shape. Some of it is still just a question we can't
          stop asking.
        </p>
      </section>
      <section className="page-wrap space-y-8 pb-20 sm:pb-28">
        {ventures.map((venture, index) => (
          <Reveal
            key={venture.id}
            id={venture.id}
            organic
            delay={index * 0.08}
            className="grid scroll-mt-24 gap-8 rounded-[2rem] border border-[hsl(var(--border))] p-8 sm:p-10 md:grid-cols-[.9fr_1.1fr]"
          >
            <div className="rounded-[1.5rem] bg-[hsl(var(--primary))] p-7 text-[hsl(var(--primary-foreground))]">
              <p className="serif text-3xl">{venture.name}</p>
              <p className="mt-2 text-sm font-semibold text-[hsl(var(--secondary))]">{venture.tagline}</p>
              <div className="mt-6 flex flex-wrap gap-2">
                {venture.nodes.map((node) => (
                  <span key={node} className="rounded-full border border-[hsl(var(--primary-foreground)/.3)] px-3 py-1 text-xs">{node}</span>
                ))}
              </div>
              <p className="mt-8 inline-flex items-center gap-2 text-xs font-bold uppercase tracking-[.1em] text-[hsl(var(--secondary))]">
                <span className="h-2 w-2 rounded-full bg-[hsl(var(--secondary))]" /> {venture.status}
              </p>
            </div>
            <div>
              <p className="eyebrow text-[hsl(var(--accent))]">{venture.eyebrow}</p>
              <div className="mt-5 space-y-5">
                {venture.story.map((item) => (
                  <div key={item.label}>
                    <p className="text-sm font-bold">{item.label}</p>
                    <p className="mt-1 text-sm leading-relaxed text-[hsl(var(--muted-foreground))]">{item.text}</p>
                  </div>
                ))}
              </div>
            </div>
          </Reveal>
        ))}
      </section>
      <section id="innovation-pipeline" className="scroll-mt-24 bg-[hsl(var(--muted))] py-20 sm:py-28">
        <div className="page-wrap">
          <SectionIntro eyebrow="Future Exploration" title="Where our curiosity is headed next." >
            These aren't products we already own — they're the questions
            keeping us up at night, in a good way.
          </SectionIntro>
          <div className="mt-12 grid gap-5 sm:grid-cols-2 lg:grid-cols-3">
            {explorationSectors.map((sector, index) => {
              const accent = accentFor(index);
              return (
                <Reveal
                  key={sector.id}
                  organic
                  delay={index * 0.04}
                  className="flex flex-col overflow-hidden rounded-[1.25rem] border border-[hsl(var(--border))] bg-[hsl(var(--background))]"
                >
                  <div className={`flex min-h-[3.75rem] items-center p-5 ${accent.bg}`}>
                    <h3 className="serif text-lg text-[hsl(var(--primary-foreground))]">{sector.title}</h3>
                  </div>
                  <p className="p-5 text-sm leading-relaxed text-[hsl(var(--muted-foreground))]">{sector.text}</p>
                </Reveal>
              );
            })}
          </div>
        </div>
      </section>
      <section className="page-wrap py-20 text-center sm:py-28">
        <Reveal><p className="eyebrow text-[hsl(var(--accent))]">Have an idea worth building?</p></Reveal>
        <Reveal delay={0.08}>
          <h2 className="serif mx-auto mt-5 max-w-2xl text-4xl leading-tight sm:text-6xl">
            Tell us where your head's at.
          </h2>
        </Reveal>
        <Reveal delay={0.16}>
          <div className="mt-8">
            <CTA href="/contact">Partner With Kennox</CTA>
          </div>
        </Reveal>
      </section>
    </>
  );
}

export function Insights() {
  return (
    <>
      <section className="page-wrap pb-16 pt-16 sm:pb-24 sm:pt-24">
        <div className="reveal">
          <p className="eyebrow text-[hsl(var(--accent))]">Thought Leadership</p>
          <h1 className="serif mt-5 max-w-3xl text-5xl leading-[1.02] tracking-[-.05em] sm:text-7xl">
            Insights.
          </h1>
          <p className="mt-7 max-w-xl text-lg leading-relaxed text-[hsl(var(--muted-foreground))]">
            Some thinking we're putting down on paper — for the builders,
            marketers and dreamers figuring out what's next for African
            business.
          </p>
        </div>
      </section>
      <section className="page-wrap pb-20 sm:pb-28">
        <div className="grid gap-8 sm:grid-cols-2 lg:grid-cols-3">
          {insights.map((article, index) => {
            const accent = accentFor(index);
            return (
              <Reveal
                key={article.title}
                organic
                delay={index * 0.05}
                className="flex flex-col overflow-hidden rounded-[1.5rem] border border-[hsl(var(--border))]"
              >
                <div className={`flex min-h-[9.5rem] items-center p-6 ${accent.bg}`}>
                  <p className="serif text-2xl leading-tight text-[hsl(var(--primary-foreground))]">
                    {article.cardLabel}
                  </p>
                </div>
                <div className="flex flex-1 flex-col p-7">
                  <p className={`eyebrow ${accent.text}`}>{article.category}</p>
                  <h3 className="serif mt-4 text-xl leading-tight">{article.title}</h3>
                  <p className="mt-3 flex-1 text-sm leading-relaxed text-[hsl(var(--muted-foreground))]">{article.text}</p>
                  <p className="mt-6 text-xs font-bold uppercase tracking-[.1em] text-[hsl(var(--muted-foreground))]">{article.status}</p>
                </div>
              </Reveal>
            );
          })}
        </div>
      </section>
    </>
  );
}

export function Careers() {
  return (
    <>
      <section className="page-wrap grid gap-10 pb-16 pt-16 sm:pb-24 sm:pt-24 lg:grid-cols-[.9fr_1.1fr] lg:items-end">
        <div className="reveal">
          <p className="eyebrow text-[hsl(var(--accent))]">Join Us</p>
          <h1 className="serif mt-5 text-5xl leading-[1.02] tracking-[-.05em] sm:text-7xl">
            Build what <em className="text-[hsl(var(--accent))]">matters.</em>
          </h1>
        </div>
        <p className="reveal reveal-delay-2 max-w-sm text-lg leading-relaxed text-[hsl(var(--muted-foreground))]">
          Be part of a team that turns possibility into something people can
          actually use — and actually believe in.
        </p>
      </section>
      <section className="page-wrap pb-20 sm:pb-28">
        <div className="grid gap-8 md:grid-cols-3">
          {careerTracks.map((track, index) => (
            <Reveal
              key={track.id}
              organic
              delay={index * 0.07}
              className="flex flex-col rounded-[1.5rem] border border-[hsl(var(--border))] p-8"
            >
              <h3 className="serif text-2xl">{track.title}</h3>
              <p className="mt-3 flex-1 text-sm leading-relaxed text-[hsl(var(--muted-foreground))]">{track.text}</p>
              <div className="mt-7">
                <CTA href="/contact">{track.cta}</CTA>
              </div>
            </Reveal>
          ))}
        </div>
      </section>
    </>
  );
}

interface FieldProps {
  label: string;
  name: string;
  value: string;
  onChange: (value: string) => void;
  placeholder: string;
  type?: string;
  error?: string;
  required?: boolean;
}

function Field({
  label,
  name,
  value,
  onChange,
  placeholder,
  type = "text",
  error,
  required = true,
}: FieldProps) {
  return (
    <label className="block">
      <span className="mb-2 block text-sm font-semibold">
        {label}
        {required && <span className="text-[hsl(var(--accent))]"> *</span>}
      </span>
      <input
        name={name}
        value={value}
        onChange={(event) => onChange(event.target.value)}
        type={type}
        placeholder={placeholder}
        className={`w-full rounded-xl border bg-[hsl(var(--card))] px-4 py-3.5 text-sm outline-none transition-colors placeholder:text-[hsl(var(--muted-foreground)/.7)] focus:border-[hsl(var(--secondary))] focus:ring-2 focus:ring-[hsl(var(--secondary)/.35)] ${error ? "border-[hsl(var(--destructive))]" : "border-[hsl(var(--border))]"}`}
        data-testid={`input-${name}`}
      />
      {error && (
        <span
          className="mt-1 block text-xs text-[hsl(var(--destructive))]"
          data-testid={`error-${name}`}
        >
          {error}
        </span>
      )}
    </label>
  );
}

const contactInitial: ContactSubmission = {
  fullName: "",
  company: "",
  email: "",
  phone: "",
  interest: "",
  message: "",
};

function ContactForm() {
  const [values, setValues] = useState<ContactSubmission>(contactInitial);
  const [error, setError] = useState("");
  const [loading, setLoading] = useState(false);
  const [sent, setSent] = useState(false);

  const update = (key: keyof ContactSubmission) => (value: string) =>
    setValues((current) => ({ ...current, [key]: value }));

  const validate = () => {
    if (!values.fullName.trim()) return "Add your full name.";
    if (!/^\S+@\S+\.\S+$/.test(values.email)) return "Add a valid email address.";
    if (!values.interest) return "Let us know what you're interested in.";
    if (!values.message.trim()) return "Tell us a little about your project.";
    return "";
  };

  const submit = async (event: React.FormEvent) => {
    event.preventDefault();
    const issue = validate();
    if (issue) {
      setError(issue);
      return;
    }
    setError("");
    setLoading(true);
    try {
      await submitContact(values);
      setSent(true);
    } catch {
      setError("Something got in the way. Please try again, or email us directly.");
    } finally {
      setLoading(false);
    }
  };

  if (sent) {
    return (
      <div className="rounded-[1.75rem] border border-[hsl(var(--border))] p-8 text-center sm:p-10">
        <Mail size={28} className="mx-auto text-[hsl(var(--secondary))]" />
        <h3 className="serif mt-5 text-2xl">Message on its way.</h3>
        <p className="mt-3 text-sm leading-relaxed text-[hsl(var(--muted-foreground))]">
          Your email client should have opened with your message ready to
          send. We'll be in touch soon.
        </p>
        <button
          type="button"
          onClick={() => {
            setValues(contactInitial);
            setSent(false);
          }}
          className="mt-6 text-sm font-semibold text-[hsl(var(--accent))]"
          data-testid="button-contact-reset"
        >
          Send another message
        </button>
      </div>
    );
  }

  return (
    <form onSubmit={submit} className="space-y-5 rounded-[1.75rem] border border-[hsl(var(--border))] p-6 sm:p-8" data-testid="form-contact">
      <div className="grid gap-5 sm:grid-cols-2">
        <Field label="Full Name" name="fullName" value={values.fullName} onChange={update("fullName")} placeholder="Your full name" />
        <Field label="Company / Organization" name="company" value={values.company} onChange={update("company")} placeholder="Your company name" required={false} />
      </div>
      <div className="grid gap-5 sm:grid-cols-2">
        <Field label="Email Address" name="email" type="email" value={values.email} onChange={update("email")} placeholder="your@email.com" />
        <Field label="Phone Number" name="phone" type="tel" value={values.phone} onChange={update("phone")} placeholder="+254 ..." required={false} />
      </div>
      <label className="block">
        <span className="mb-2 block text-sm font-semibold">
          What are you interested in? <span className="text-[hsl(var(--accent))]">*</span>
        </span>
        <select
          name="interest"
          value={values.interest}
          onChange={(event) => update("interest")(event.target.value)}
          className="w-full rounded-xl border border-[hsl(var(--border))] bg-[hsl(var(--card))] px-4 py-3.5 text-sm outline-none focus:border-[hsl(var(--secondary))] focus:ring-2 focus:ring-[hsl(var(--secondary)/.35)]"
          data-testid="select-interest"
        >
          <option value="">Select an option</option>
          {contactInterests.map((option) => (
            <option key={option.value} value={option.label}>{option.label}</option>
          ))}
        </select>
      </label>
      <label className="block">
        <span className="mb-2 block text-sm font-semibold">
          Tell us about your project <span className="text-[hsl(var(--accent))]">*</span>
        </span>
        <textarea
          name="message"
          value={values.message}
          onChange={(event) => update("message")(event.target.value)}
          placeholder="Describe your project, goals and any specific requirements..."
          rows={5}
          className="w-full rounded-xl border border-[hsl(var(--border))] bg-[hsl(var(--card))] px-4 py-3.5 text-sm outline-none focus:border-[hsl(var(--secondary))] focus:ring-2 focus:ring-[hsl(var(--secondary)/.35)]"
          data-testid="input-message"
        />
      </label>
      {error && <p className="text-sm text-[hsl(var(--destructive))]" data-testid="error-contact-form">{error}</p>}
      <button
        type="submit"
        disabled={loading}
        className="inline-flex items-center gap-2 rounded-full bg-[hsl(var(--primary))] px-6 py-3.5 text-[.7rem] font-bold uppercase tracking-[.12em] text-[hsl(var(--primary-foreground))] transition-transform hover:-translate-y-0.5 disabled:opacity-60"
        data-testid="button-contact-submit"
      >
        {loading ? "Sending..." : "Start the Conversation"} <ArrowUpRight size={15} />
      </button>
    </form>
  );
}

export function Contact() {
  return (
    <>
      <section className="page-wrap grid gap-10 pb-16 pt-16 sm:pb-24 sm:pt-24 lg:grid-cols-[1fr_.8fr]">
        <div className="reveal">
          <p className="eyebrow text-[hsl(var(--accent))]">Get In Touch</p>
          <h1 className="serif mt-5 max-w-3xl text-5xl leading-[1.02] tracking-[-.05em] sm:text-7xl">
            Let's build something{" "}
            <em className="text-[hsl(var(--accent))]">meaningful.</em>
          </h1>
        </div>
        <p className="reveal reveal-delay-2 max-w-sm self-end text-lg leading-relaxed text-[hsl(var(--muted-foreground))]">
          Whether you're ready to start or still turning an idea over in
          your head, there's no wrong way to reach out.
        </p>
      </section>
      <section className="page-wrap grid gap-12 pb-24 lg:grid-cols-[.75fr_1.25fr]">
        <div className="space-y-8">
          <Reveal>
            <p className="eyebrow text-[hsl(var(--accent))]">Visit</p>
            <p className="mt-3 text-xl font-semibold">{contactInfo.location}</p>
            <p className="mt-1 text-sm text-[hsl(var(--muted-foreground))]">{contactInfo.locationNote}</p>
          </Reveal>
          <Reveal delay={0.06}>
            <p className="eyebrow text-[hsl(var(--accent))]">Email</p>
            <a
              href={`mailto:${contactInfo.email}`}
              className="mt-3 inline-block break-all text-xl font-semibold underline decoration-[hsl(var(--secondary))] decoration-2 underline-offset-4"
              data-testid="link-contact-email"
            >
              {contactInfo.email}
            </a>
          </Reveal>
          <Reveal delay={0.12}>
            <p className="eyebrow text-[hsl(var(--accent))]">Phone</p>
            <a
              href={`tel:${contactInfo.phone.replace(/\s+/g, "")}`}
              className="mt-3 inline-block text-lg font-semibold"
              data-testid="link-contact-phone"
            >
              {contactInfo.phone}
            </a>
          </Reveal>
          <Reveal delay={0.16}>
            <p className="eyebrow text-[hsl(var(--accent))]">Business Hours</p>
            <p className="mt-3 text-sm font-semibold">{contactInfo.hours}</p>
          </Reveal>
          <Reveal delay={0.22} className="overflow-hidden rounded-2xl border border-[hsl(var(--border))] shadow-[var(--shadow-sm)]">
            <iframe
              title="Map showing Eldoret, Kenya"
              src="https://www.google.com/maps?q=Eldoret,Kenya&output=embed"
              className="h-56 w-full border-0"
              loading="lazy"
            />
          </Reveal>
        </div>
        <div className="space-y-5">
          <ConversationOptions context="contact" />
          <ContactForm />
        </div>
      </section>
    </>
  );
}

export function NotFound() {
  return (
    <section className="page-wrap flex min-h-[70vh] flex-col items-start justify-center">
      <p className="eyebrow text-[hsl(var(--accent))]">Page not found</p>
      <h1 className="serif mt-5 text-6xl">A wrong turn.</h1>
      <p className="mt-4 text-[hsl(var(--muted-foreground))]">
        The page you are looking for cannot be found.
      </p>
      <div className="mt-7">
        <CTA href="/">Back to home</CTA>
      </div>
    </section>
  );
}
KENNOX_96B075EA66
echo "  wrote artifacts/kennox-solutions/src/pages/Pages.tsx"

mkdir -p "$(dirname "artifacts/kennox-solutions/src/components/Marketing.tsx")"
cat > "artifacts/kennox-solutions/src/components/Marketing.tsx" << 'KENNOX_04D8CE1309'
import { ArrowRight, Check, Cpu, Megaphone, Quote, Rocket, Sparkles } from 'lucide-react';
import { type ReactNode, useEffect, useRef, useState } from 'react';
import { Reveal } from '@/components/Reveal';
import { services, testimonials, values, type ServicePillar } from '@/data/site';

const iconMap = { sparkles: Sparkles, megaphone: Megaphone, cpu: Cpu, rocket: Rocket };

// Cycling accent palette for branded "topic" card headers — literal class
// strings so Tailwind's static scanner can pick them up at build time.
// Gold is intentionally excluded here (too low-contrast/dull for these
// blocks) — green and maroon alternate instead.
const accents = [
  { bg: 'bg-[hsl(var(--primary))]', text: 'text-[hsl(var(--primary))]' },
  { bg: 'bg-[hsl(var(--accent))]', text: 'text-[hsl(var(--accent))]' },
];
export function accentFor(index: number) {
  return accents[index % accents.length];
}

export function SectionIntro({ eyebrow, title, children, dark = false }: { eyebrow: string; title: ReactNode; children?: ReactNode; dark?: boolean }) {
  return <div className={`max-w-2xl ${dark ? 'text-[hsl(var(--primary-foreground))]' : ''}`}>
    <Reveal as="span" className="eyebrow block"><span className={dark ? 'text-[hsl(var(--secondary))]' : 'text-[hsl(var(--accent))]'}>{eyebrow}</span></Reveal>
    <Reveal delay={0.08}><h2 className="serif mt-4 text-4xl leading-[1.05] tracking-[-.03em] sm:text-5xl md:text-6xl">{title}</h2></Reveal>
    {children && <Reveal delay={0.16}><div className={`mt-5 max-w-lg text-base leading-relaxed ${dark ? 'text-[hsl(var(--primary-foreground)/.7)]' : 'text-[hsl(var(--muted-foreground))]'}`}>{children}</div></Reveal>}
  </div>;
}

export function ArtPanel({ compact = false }: { compact?: boolean }) {
  const ringSize = compact
    ? 'left-[24%] top-[10%] h-[36%] w-[36%] border-[10px] shadow-[0_0_0_6px_hsl(var(--primary)),0_0_0_7px_hsl(var(--secondary)/.3)] sm:left-[20%] sm:top-[12%] sm:h-[40%] sm:w-[40%] sm:border-[13px]'
    : 'left-[20%] top-[12%] h-[40%] w-[40%] border-[12px] shadow-[0_0_0_7px_hsl(var(--primary)),0_0_0_8px_hsl(var(--secondary)/.3)] sm:left-[17%] sm:top-[14%] sm:h-[44%] sm:w-[44%] sm:border-[14px] sm:shadow-[0_0_0_9px_hsl(var(--primary)),0_0_0_10px_hsl(var(--secondary)/.3)]';
  return <div className={`relative overflow-hidden rounded-[1.75rem] bg-[hsl(var(--primary))] ${compact ? 'h-[220px]' : 'h-[240px] sm:h-auto sm:min-h-[260px]'} p-5 sm:p-6 text-[hsl(var(--primary-foreground))]`}>
    <div className="absolute -right-16 -top-16 h-64 w-64 rounded-full border-[1px] border-[hsl(var(--secondary)/.4)]" /><div className="absolute -right-3 top-0 h-56 w-56 rounded-full border-[1px] border-[hsl(var(--secondary)/.25)]" />
    <div className="absolute -bottom-28 -left-24 h-80 w-80 rounded-full bg-[hsl(var(--secondary)/.28)] blur-3xl" />
    <div className={`absolute rotate-12 rounded-full border-[hsl(var(--secondary))] ${ringSize}`}>
      <div className="absolute inset-[15%] rounded-full border border-[hsl(var(--primary)/.4)]" /><div className="absolute inset-[31%] rounded-full bg-[hsl(var(--secondary))]" /><div className="absolute inset-[43%] rounded-full bg-[hsl(var(--secondary))]" />
    </div>
    <div className="absolute right-5 top-5 grid h-9 w-9 shrink-0 place-items-center rounded-full border border-[hsl(var(--primary-foreground)/.35)] sm:right-6 sm:top-6 sm:h-10 sm:w-10"><Sparkles size={14} /></div>
    <div className="absolute inset-x-5 bottom-5 z-10 sm:inset-x-6 sm:bottom-6">
      <p className="eyebrow text-[hsl(var(--secondary))]">Brand · Technology · Innovations</p>
      <p className="serif mt-1.5 max-w-[15rem] text-lg italic leading-tight sm:text-xl">Turning ideas into meaningful solutions.</p>
    </div>
  </div>;
}

const marqueeItems: ReactNode[] = [
  <span key="s1" className="serif text-lg italic text-[hsl(var(--primary-foreground))]">"{testimonials[0].quote.split('.')[0]}."</span>,
  <span key="f1" className="flex items-center gap-2 text-sm font-bold uppercase tracking-[.14em] text-[hsl(var(--secondary))]"><span className="serif text-xl not-italic">{values.length.toString().padStart(2, '0')}</span> values behind every project</span>,
  <span key="s2" className="serif text-lg italic text-[hsl(var(--primary-foreground))]">"{testimonials[1].quote.split('.')[0]}."</span>,
  <span key="f2" className="text-sm font-bold uppercase tracking-[.14em] text-[hsl(var(--secondary))]">Real ideas. Real strategy. Real impact.</span>,
  <span key="s3" className="serif text-lg italic text-[hsl(var(--primary-foreground))]">"{testimonials[2].quote.split('.')[0]}."</span>,
  <span key="f3" className="flex items-center gap-2 text-sm font-bold uppercase tracking-[.14em] text-[hsl(var(--secondary))]"><span className="serif text-xl not-italic">{services.length.toString().padStart(2, '0')}</span> ways to bring your idea to life</span>,
];

export function KennoxMarquee({ className = '' }: { className?: string }) {
  const track = [...marqueeItems, ...marqueeItems];
  return (
    <div className={`marquee-mask overflow-hidden bg-[hsl(var(--primary))] py-2.5 ${className}`}>
      <div className="marquee-track flex w-max items-center gap-10">
        {track.map((item, index) => (
          <span key={index} className="flex items-center gap-10">
            {item}
            <Sparkles size={14} className="shrink-0 text-[hsl(var(--secondary)/.5)]" />
          </span>
        ))}
      </div>
    </div>
  );
}

export function ServiceCard({ service, active, onSelect }: { service: ServicePillar; active: boolean; onSelect: () => void }) {
  const Icon = iconMap[service.icon];
  return <button type="button" onClick={onSelect} className={`group flex w-full items-start gap-4 border-t py-5 text-left transition-colors ${active ? 'border-[hsl(var(--secondary))] text-[hsl(var(--primary-foreground))]' : 'border-[hsl(var(--primary-foreground)/.25)] text-[hsl(var(--primary-foreground)/.72)] hover:text-[hsl(var(--primary-foreground))]'}`} data-testid={`button-service-${service.id}`}><span className={`eyebrow pt-1 ${active ? 'text-[hsl(var(--secondary))]' : 'text-[hsl(var(--primary-foreground)/.58)]'}`}>{service.number}</span><span className="flex-1"><span className="block text-lg font-semibold">{service.title}</span><span className="mt-1 block text-sm">{service.short}</span></span><span className={`grid h-9 w-9 shrink-0 place-items-center rounded-full border transition-all ${active ? 'rotate-45 border-[hsl(var(--secondary))] bg-[hsl(var(--secondary))] text-[hsl(var(--primary))]' : 'border-[hsl(var(--primary-foreground)/.3)] group-hover:border-[hsl(var(--primary-foreground))]'}`}><Icon size={15} /></span></button>;
}

export function ServiceExplorer({ limit }: { limit?: number }) {
  const shown = limit ? services.slice(0, limit) : services;
  const [activeId, setActiveId] = useState(shown[0].id);
  const active = shown.find((service) => service.id === activeId) ?? shown[0];

  return <div className="grid items-start gap-10 lg:grid-cols-[1.35fr_1fr] lg:gap-14"><div className="grid gap-x-8 sm:grid-cols-2">{shown.map((service) => <ServiceCard key={service.id} service={service} active={service.id === active.id} onSelect={() => setActiveId(service.id)} />)}</div><div key={active.id} className="reveal relative overflow-hidden rounded-[1.75rem] bg-[hsl(var(--background))] p-8 text-[hsl(var(--foreground))] shadow-[var(--shadow-md)] sm:p-10"><div className="absolute -right-16 -top-16 h-52 w-52 rounded-full border-[22px] border-[hsl(var(--secondary)/.75)]" /><div className="absolute -bottom-20 -left-16 h-48 w-48 rounded-full bg-[hsl(var(--secondary)/.3)] blur-2xl" /><div className="relative"><p className="eyebrow text-[hsl(var(--accent))]">A closer look / {active.number}</p><h3 className="serif mt-6 max-w-md text-3xl leading-tight sm:text-4xl">{active.title}</h3><p className="mt-4 max-w-md leading-relaxed text-[hsl(var(--muted-foreground))]">{active.description}</p><ul className="mt-6 grid gap-3">{active.detail.map((item) => <li key={item} className="flex items-start gap-2 text-sm font-semibold"><Check size={15} className="mt-0.5 shrink-0 text-[hsl(var(--secondary))]" />{item}</li>)}</ul></div></div></div>;
}

export function PillarsBand() {
  return <div className="grid gap-6 sm:grid-cols-3">
    {[
      { title: 'Brand', text: 'Identity, creativity & communication' },
      { title: 'Technology', text: 'Systems, intelligence & platforms' },
      { title: 'Innovations', text: 'Experimentation, ventures & future' },
    ].map((pillar, index) => (
      <Reveal key={pillar.title} organic delay={index * 0.07} className="rounded-[1.5rem] border border-[hsl(var(--primary-foreground)/.2)] p-7">
        <p className="eyebrow text-[hsl(var(--secondary))]">{pillar.title}</p>
        <p className="mt-3 text-sm leading-relaxed text-[hsl(var(--primary-foreground)/.72)]">{pillar.text}</p>
      </Reveal>
    ))}
  </div>;
}

export function ArrowLink({ href, children }: { href: string; children: ReactNode }) {
  return <a href={href} className="inline-flex items-center gap-1.5 text-sm font-semibold text-[hsl(var(--accent))]">{children} <ArrowRight size={14} /></a>;
}

export function TestimonialSlideshow() {
  const [index, setIndex] = useState(0);
  const [paused, setPaused] = useState(false);
  const timerRef = useRef<ReturnType<typeof setInterval> | null>(null);

  useEffect(() => {
    const prefersReducedMotion = window.matchMedia('(prefers-reduced-motion: reduce)').matches;
    if (prefersReducedMotion || paused) return;
    timerRef.current = setInterval(() => {
      setIndex((current) => (current + 1) % testimonials.length);
    }, 5500);
    return () => {
      if (timerRef.current) clearInterval(timerRef.current);
    };
  }, [paused]);

  const active = testimonials[index];

  return (
    <div
      className="relative overflow-hidden rounded-[1.75rem] border border-[hsl(var(--border))] bg-[hsl(var(--muted)/.4)] p-8 sm:p-12"
      onMouseEnter={() => setPaused(true)}
      onMouseLeave={() => setPaused(false)}
      onFocus={() => setPaused(true)}
      onBlur={() => setPaused(false)}
      data-testid="testimonial-slideshow"
    >
      <Quote size={32} className="text-[hsl(var(--secondary))]" />
      <div key={index} className="reveal mt-6 min-h-[7.5rem] sm:min-h-[6rem]">
        <p className="serif max-w-2xl text-2xl leading-snug sm:text-3xl">"{active.quote}"</p>
        <p className="mt-6 text-sm font-bold uppercase tracking-[.1em] text-[hsl(var(--muted-foreground))]">
          {active.name} <span className="font-normal normal-case tracking-normal">— {active.role}</span>
        </p>
      </div>
      <div className="mt-8 flex items-center gap-2">
        {testimonials.map((testimonial, dotIndex) => (
          <button
            key={testimonial.name}
            type="button"
            onClick={() => setIndex(dotIndex)}
            aria-label={`Show testimonial ${dotIndex + 1}`}
            className={`h-1.5 rounded-full transition-all ${dotIndex === index ? 'w-7 bg-[hsl(var(--secondary))]' : 'w-1.5 bg-[hsl(var(--border))]'}`}
            data-testid={`dot-testimonial-${dotIndex}`}
          />
        ))}
        <span className="ml-3 text-[.65rem] font-semibold uppercase tracking-[.1em] text-[hsl(var(--muted-foreground)/.7)]">Sample content</span>
      </div>
    </div>
  );
}
KENNOX_04D8CE1309
echo "  wrote artifacts/kennox-solutions/src/components/Marketing.tsx"

echo "==> Done. Re-run: bash 03-verify-and-build.sh"
