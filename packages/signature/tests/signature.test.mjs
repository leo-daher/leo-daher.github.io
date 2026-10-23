import test from 'node:test';
import assert from 'node:assert/strict';
import {readFile} from 'node:fs/promises';
import {renderSignature, signatureContent, signatureStyles} from '../web/index.mjs';

test('localized static signatures work without a browser, scripts, fonts or remote assets', () => {
  for (const [locale,label,path] of [['pt-BR','Desenvolvido por','/pt/'],['en','Developed by','/'],['es','Desarrollado por','/']]) {
    const html=renderSignature({locale,id:`example-${locale}`});
    assert.ok(html.includes(label));
    assert.ok(html.includes(`href="https://leo-daher.github.io${path}"`));
    assert.match(html,/rel="noopener noreferrer"/);
    assert.doesNotMatch(html,/<script|<img|<style|on[a-z]+=/i);
    assert.equal((html.match(/aria-hidden="true"/g)||[]).length,4);
  }
});
test('independent instances have no shared mask IDs and preserve the official geometry', () => {
  const first=renderSignature({id:'first'}), second=renderSignature({id:'second'});
  assert.match(first,/id="first-dark"/);
  assert.doesNotMatch(second,/first-dark/);
  assert.match(first,/M24 50V196Q24 232 60 232H180/);
  assert.match(first,/#FF6B55/);
});
test('untrusted options cannot introduce markup or arbitrary destinations', () => {
  assert.throws(()=>renderSignature({id:'x" onload="alert(1)'}),TypeError);
  assert.throws(()=>renderSignature({variant:'<script>'}),TypeError);
  assert.throws(()=>renderSignature({theme:'bad'}),TypeError);
  assert.equal(signatureContent({locale:'<script>'}).href,'https://leo-daher.github.io/');
});
test('packaged SVG assets and generated CSS match the canonical sources', async () => {
  for(const name of ['ld-mark.svg','ld-mark-inverse.svg']) {
    assert.equal(await readFile(new URL(`../assets/${name}`,import.meta.url),'utf8'),await readFile(new URL(`../../../assets/brand/${name}`,import.meta.url),'utf8'));
  }
  assert.equal(signatureStyles,await readFile(new URL('../web/styles.css',import.meta.url),'utf8'));
});
