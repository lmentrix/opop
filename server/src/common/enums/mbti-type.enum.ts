export enum MBTIType {
  // Analysts
  INTJ = 'INTJ', // Architect
  INTP = 'INTP', // Thinker
  ENTJ = 'ENTJ', // Commander
  ENTP = 'ENTP', // Debater

  // Diplomats
  INFJ = 'INFJ', // Advocate
  INFP = 'INFP', // Mediator
  ENFJ = 'ENFJ', // Protagonist
  ENFP = 'ENFP', // Campaigner

  // Sentinels
  ISTJ = 'ISTJ', // Logistician
  ISFJ = 'ISFJ', // Protector
  ESTJ = 'ESTJ', // Executive
  ESFJ = 'ESFJ', // Consul

  // Explorers
  ISTP = 'ISTP', // Virtuoso
  ISFP = 'ISFP', // Adventurer
  ESTP = 'ESTP', // Entrepreneur
  ESFP = 'ESFP', // Entertainer
}

export enum MBTICategory {
  ANALYST = 'ANALYST',
  DIPLOMAT = 'DIPLOMAT',
  SENTINEL = 'SENTINEL',
  EXPLORER = 'EXPLORER',
}

export enum CognitiveFunction {
  // Dominant Functions
  NI = 'Ni', // Introverted Intuition
  NE = 'Ne', // Extraverted Intuition
  SI = 'Si', // Introverted Sensing
  SE = 'Se', // Extraverted Sensing
  FI = 'Fi', // Introverted Feeling
  FE = 'Fe', // Extraverted Feeling
  TI = 'Ti', // Introverted Thinking
  TE = 'Te', // Extraverted Thinking
}

export const MBTI_CATEGORY_MAP: Record<MBTIType, MBTICategory> = {
  [MBTIType.INTJ]: MBTICategory.ANALYST,
  [MBTIType.INTP]: MBTICategory.ANALYST,
  [MBTIType.ENTJ]: MBTICategory.ANALYST,
  [MBTIType.ENTP]: MBTICategory.ANALYST,
  [MBTIType.INFJ]: MBTICategory.DIPLOMAT,
  [MBTIType.INFP]: MBTICategory.DIPLOMAT,
  [MBTIType.ENFJ]: MBTICategory.DIPLOMAT,
  [MBTIType.ENFP]: MBTICategory.DIPLOMAT,
  [MBTIType.ISTJ]: MBTICategory.SENTINEL,
  [MBTIType.ISFJ]: MBTICategory.SENTINEL,
  [MBTIType.ESTJ]: MBTICategory.SENTINEL,
  [MBTIType.ESFJ]: MBTICategory.SENTINEL,
  [MBTIType.ISTP]: MBTICategory.EXPLORER,
  [MBTIType.ISFP]: MBTICategory.EXPLORER,
  [MBTIType.ESTP]: MBTICategory.EXPLORER,
  [MBTIType.ESFP]: MBTICategory.EXPLORER,
};