import { spellCheckDocument } from 'cspell-lib';




async function checkSpelling(phrase: string) {
  const result = await spellCheckDocument(
    { uri: '', text: phrase, languageId: 'plaintext', locale: 'en,it' },
    {  noConfigSearch: true },
    { }
  );
  return result.issues;
}

export async function run() {
  console.log(`Start: ${new Date().toISOString()}`);
  const r = await checkSpelling('These are my coztom wordz. Processore');
  console.log(`End: ${new Date().toISOString()}`);
  //console.log('%o', r);
}

await run();
await run();
await run();
