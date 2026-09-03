import { Bot, MessageCircle, Send, X } from "lucide-react";
import { type FormEvent, useEffect, useRef, useState } from "react";
import { useLocation } from "wouter";

const CHAT_EVENT = "kennox:open-chat";
const WHATSAPP_NUMBER = "254727321145";

type ChatMessage = {
  id: string;
  role: "bot" | "visitor";
  text: string;
};

const welcomeMessage: ChatMessage = {
  id: "welcome",
  role: "bot",
  text: "Hi, I’m the Kennox guide. What would you like to explore?",
};

const quickQuestions = [
  "What services do you offer?",
  "Tell me about the Innovation Lab.",
  "Can I book a conversation?",
];

export function whatsappHref(context = "Kennox Solutions") {
  const message =
    context === "Innovation Lab"
      ? "Hello Kennox, I would like to learn more about the Innovation Lab and your ventures."
      : "Hello Kennox, I would like to start a conversation about your services.";
  return `https://wa.me/${WHATSAPP_NUMBER}?text=${encodeURIComponent(message)}`;
}

export function openSupportChat() {
  window.dispatchEvent(new Event(CHAT_EVENT));
}

function getBotReply(question: string) {
  const normalized = question.toLowerCase();
  if (normalized.includes("service") || normalized.includes("offer")) {
    return "We combine brand, marketing & growth, technology, and innovation. You can explore the full list on What We Do.";
  }
  if (normalized.includes("innovation") || normalized.includes("lab") || normalized.includes("venture")) {
    return "Our Innovation Lab is where we explore ventures like Doktaz Plaza and Kennox Arena. Take a look on the Innovation Lab page.";
  }
  if (normalized.includes("book") || normalized.includes("conversation") || normalized.includes("contact")) {
    return "Absolutely. Use Contact to send a message, or choose WhatsApp here for a quicker hello.";
  }
  return "Thanks for reaching out. A good next step is to share a little about your project on Contact, or explore What We Do.";
}

export function ConversationOptions({ context }: { context: "contact" | "innovation" }) {
  const isInnovation = context === "innovation";
  return (
    <div className="rounded-[1.25rem] border border-[hsl(var(--border))] bg-[hsl(var(--muted)/.55)] p-5 sm:p-6">
      <p className="eyebrow text-[hsl(var(--accent))]">Choose your hello</p>
      <p className="mt-2 max-w-md text-sm leading-relaxed text-[hsl(var(--muted-foreground))]">
        {isInnovation
          ? "Ask about our ventures through WhatsApp or ask the Kennox guide what happens next."
          : "Send the details through the form, message us on WhatsApp, or ask a quick question first."}
      </p>
      <div className="mt-4 grid gap-3 sm:grid-cols-2">
        <a
          href={whatsappHref(isInnovation ? "Innovation Lab" : "Kennox Solutions")}
          target="_blank"
          rel="noreferrer"
          className="inline-flex min-h-11 items-center justify-center gap-2 rounded-full bg-[#25D366] px-4 py-3 text-[.68rem] font-bold uppercase tracking-[.1em] text-[#073B1A] transition-transform hover:-translate-y-0.5"
          data-testid={`link-${context}-whatsapp`}
        >
          <MessageCircle size={16} fill="currentColor" /> WhatsApp
        </a>
        <button
          type="button"
          onClick={openSupportChat}
          className="inline-flex min-h-11 items-center justify-center gap-2 rounded-full border border-[hsl(var(--primary))] px-4 py-3 text-[.68rem] font-bold uppercase tracking-[.1em] text-[hsl(var(--primary))] transition-colors hover:bg-[hsl(var(--primary))] hover:text-[hsl(var(--primary-foreground))]"
          data-testid={`button-${context}-chat`}
        >
          <Bot size={16} /> Chat directly
        </button>
      </div>
    </div>
  );
}

export function SupportTools() {
  const [open, setOpen] = useState(false);
  const [draft, setDraft] = useState("");
  const [messages, setMessages] = useState<ChatMessage[]>([welcomeMessage]);
  const inputRef = useRef<HTMLInputElement>(null);
  const [location] = useLocation();
  // Special case for the home hero: float the launcher above the full-bleed
  // marquee bar and stack the two buttons, matching the reference mock-up.
  // Every other page keeps the standard bottom-right, side-by-side layout.
  const isHome = location === "/";

  useEffect(() => {
    const openChat = () => setOpen(true);
    window.addEventListener(CHAT_EVENT, openChat);
    return () => window.removeEventListener(CHAT_EVENT, openChat);
  }, []);

  useEffect(() => {
    if (open) inputRef.current?.focus();
  }, [open]);

  const sendMessage = (message = draft) => {
    const text = message.trim();
    if (!text) return;
    setMessages((current) => [
      ...current,
      { id: `${Date.now()}-visitor`, role: "visitor", text },
      { id: `${Date.now()}-bot`, role: "bot", text: getBotReply(text) },
    ]);
    setDraft("");
  };

  const submit = (event: FormEvent<HTMLFormElement>) => {
    event.preventDefault();
    sendMessage();
  };

  return (
    <div className={`fixed right-4 z-50 flex flex-col items-end gap-3 sm:right-6 ${isHome ? "bottom-24 sm:bottom-28" : "bottom-5"}`}>
      {open && (
        <div
          className="w-[min(calc(100vw-2rem),380px)] overflow-hidden rounded-[1.25rem] border border-[hsl(var(--border))] bg-[hsl(var(--background))] shadow-[var(--shadow-lg)]"
          role="dialog"
          aria-label="Kennox chat"
          data-testid="chatbot-panel"
        >
          <div className="flex items-center justify-between bg-[hsl(var(--primary))] px-5 py-4 text-[hsl(var(--primary-foreground))]">
            <div className="flex items-center gap-3">
              <span className="grid h-9 w-9 place-items-center rounded-full bg-[hsl(var(--secondary))] text-[hsl(var(--primary))]">
                <Bot size={18} />
              </span>
              <div>
                <p className="text-sm font-bold">The Kennox guide</p>
                <p className="text-xs text-[hsl(var(--primary-foreground)/.68)]">Here to help you find your next step</p>
              </div>
            </div>
            <button type="button" onClick={() => setOpen(false)} aria-label="Close chat" className="grid h-9 w-9 place-items-center rounded-full border border-[hsl(var(--primary-foreground)/.25)] hover:bg-[hsl(var(--primary-foreground)/.1)]" data-testid="button-close-chat">
              <X size={17} />
            </button>
          </div>
          <div className="max-h-72 space-y-3 overflow-y-auto p-4" aria-live="polite">
            {messages.map((message) => (
              <div key={message.id} className={`flex ${message.role === "visitor" ? "justify-end" : "justify-start"}`}>
                <p className={`max-w-[88%] rounded-2xl px-3.5 py-2.5 text-sm leading-relaxed ${message.role === "visitor" ? "rounded-br-md bg-[hsl(var(--primary))] text-[hsl(var(--primary-foreground))]" : "rounded-bl-md bg-[hsl(var(--muted))] text-[hsl(var(--foreground))]"}`}>
                  {message.text}
                </p>
              </div>
            ))}
          </div>
          <div className="border-t border-[hsl(var(--border))] p-4">
            <div className="mb-3 flex gap-2 overflow-x-auto pb-1">
              {quickQuestions.map((question) => (
                <button key={question} type="button" onClick={() => sendMessage(question)} className="shrink-0 rounded-full border border-[hsl(var(--border))] px-3 py-2 text-left text-xs text-[hsl(var(--muted-foreground))] hover:border-[hsl(var(--accent))] hover:text-[hsl(var(--foreground))]">
                  {question}
                </button>
              ))}
            </div>
            <form onSubmit={submit} className="flex items-center gap-2">
              <input ref={inputRef} value={draft} onChange={(event) => setDraft(event.target.value)} placeholder="Ask a quick question…" aria-label="Chat message" className="min-w-0 flex-1 rounded-full border border-[hsl(var(--border))] bg-[hsl(var(--card))] px-4 py-3 text-sm outline-none focus:border-[hsl(var(--secondary))] focus:ring-2 focus:ring-[hsl(var(--secondary)/.3)]" data-testid="input-chat-message" />
              <button type="submit" aria-label="Send chat message" className="grid h-11 w-11 shrink-0 place-items-center rounded-full bg-[hsl(var(--secondary))] text-[hsl(var(--primary))]" data-testid="button-send-chat">
                <Send size={16} />
              </button>
            </form>
          </div>
        </div>
      )}
      <div className={isHome ? "flex flex-col items-center gap-3" : "flex items-center gap-3"}>
        <a href={whatsappHref()} target="_blank" rel="noreferrer" aria-label="Chat with Kennox on WhatsApp" title="Chat on WhatsApp" className="grid h-12 w-12 place-items-center rounded-full bg-[#25D366] text-[#073B1A] shadow-[var(--shadow-md)] ring-2 ring-[hsl(var(--background))] transition-transform hover:-translate-y-0.5" data-testid="button-global-whatsapp">
          <MessageCircle size={22} fill="currentColor" />
        </a>
        <button type="button" onClick={() => setOpen((current) => !current)} aria-label={open ? "Close Kennox chat" : "Open Kennox chat"} title="Chat with Kennox" className="grid h-14 w-14 place-items-center rounded-full bg-[hsl(var(--secondary))] text-[hsl(var(--primary))] shadow-[var(--shadow-md)] ring-2 ring-[hsl(var(--background))] transition-transform hover:-translate-y-0.5" data-testid="button-global-chat">
          {open ? <X size={21} /> : <Bot size={21} />}
        </button>
      </div>
    </div>
  );
}
