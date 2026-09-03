import { type CSSProperties, type ReactNode, useMemo } from 'react';
import { useInView } from '@/hooks/use-in-view';

type RevealProps = {
  children: ReactNode;
  as?: 'div' | 'span';
  delay?: number;
  className?: string;
  id?: string;
  /** Adds a small per-instance random tilt/drift so groups of items don't move in lockstep. */
  organic?: boolean;
};

/**
 * Wraps content so it fades/rises into place the first time it scrolls into
 * view, instead of animating once on mount regardless of scroll position.
 * With `organic`, each instance gets a slightly randomized starting tilt and
 * delay so a group (cards, list items) feels alive rather than mechanical.
 */
export function Reveal({ children, as = 'div', delay = 0, className = '', id, organic = false }: RevealProps) {
  const { ref, inView } = useInView();
  const Tag = as;

  const jitter = useMemo(() => {
    if (!organic) return { rotate: 0, extraDelay: 0, x: 0 };
    return {
      rotate: (Math.random() - 0.5) * 3.2,
      extraDelay: Math.random() * 0.22,
      x: (Math.random() - 0.5) * 10,
    };
  }, [organic]);

  const style: CSSProperties = {
    transitionDelay: `${delay + jitter.extraDelay}s`,
    transform: inView ? 'translateY(0) translateX(0) rotate(0deg)' : `translateY(18px) translateX(${jitter.x}px) rotate(${jitter.rotate}deg)`,
    opacity: inView ? 1 : 0,
    transitionProperty: 'transform, opacity',
    transitionDuration: '.8s',
    transitionTimingFunction: 'cubic-bezier(.2,.7,.2,1)',
    willChange: 'transform, opacity',
  };

  return (
    // biome-ignore lint: dynamic tag is intentional here
    <Tag ref={ref as never} id={id} className={className} style={style}>
      {children}
    </Tag>
  );
}
