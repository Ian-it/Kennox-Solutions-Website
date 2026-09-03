export interface MemberProfile {
  firstName: string;
  lastName: string;
  phone: string;
  loginEmail: string;
}

const defaultProfile: MemberProfile = {
  firstName: 'Maya',
  lastName: 'Achieng',
  phone: '+254 700 000 000',
  loginEmail: 'maya@example.com',
};

const profileKey = 'kennox-member-profile';

export function getProfile(): MemberProfile {
  try {
    const stored = window.localStorage.getItem(profileKey);
    return stored ? { ...defaultProfile, ...JSON.parse(stored) } : defaultProfile;
  } catch {
    return defaultProfile;
  }
}

export function updateProfile(profile: MemberProfile): MemberProfile {
  window.localStorage.setItem(profileKey, JSON.stringify(profile));
  return profile;
}