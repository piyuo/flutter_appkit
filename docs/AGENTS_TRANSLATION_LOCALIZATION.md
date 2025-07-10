# 🌍 Workflow 4: Translation/Localization/i18n

<!--
===============================================
Document: AGENTS_TRANSLATION_LOCALIZATION.md
Purpose: Guide AI assistants through translation and localization operations

Overview:
  - Translation request triggers and context assessment
  - Process Steps:
    1. Context Assessment & Setup → Understand i18n setup and current state
    2. Language Detection & Text Processing → Source language detection and grammar correction
    3. Translation Operations → Add, delete, update translations
    4. Quality Review → Contextual analysis and improvements
    5. Build & Generation → Execute required scripts
    6. Quality Validation → Final checks
    7. Documentation & Commit → Proper commit strategy

Key Operations:
  - Add New Translation → Key-value pairs for all supported languages
  - Delete Translation → Remove from all language files
  - Update Translation Key → Rename keys consistently
  - Update Translation Text → Improve existing translations

Critical Dependencies:
  - README.md → Localization/i18n setup, file formats, build procedures
  - Translation files → Current translations and structure
  - Build scripts → Generation and validation procedures

Quality Standards:
  - Grammar and vocabulary correction for source language
  - Cultural appropriateness for all target languages
  - Consistency across entire translation project
  - Complete coverage for all supported languages
===============================================
-->

**Trigger:** Human asks for translation help, such as:
- "add translation key: error_text, text: something wrong with this error"
- "add new translation"
- "delete key from translation"
- "update translation key"
- "localize this text"

**Prerequisites:** Working on existing project with i18n setup

**🚨 CRITICAL: Before starting, read README.md for localization/i18n setup, file formats, and required scripts.**

## Step 1: Context Assessment & Setup

**Understand Current State:**

- [ ] Read README.md to find localization/i18n section
- [ ] Identify translation file format (CSV, JSON, etc.)
- [ ] Locate translation files in the project
- [ ] Understand the project's supported languages
- [ ] Check if there are build scripts or generation procedures

**📖 Essential References (Read These):**

- **README.md** → Localization setup, file formats, build procedures
- **Translation files** → Current translations and structure

### Step 2: Language Detection & Text Processing

**2a. Detect Source Language:**

1. **Analyze the provided text** to determine the source language
2. **Default assumption:** English (en-US) unless clearly another language
3. **Common indicators:**
   - Chinese characters → Chinese (zh-CN or zh-TW)
   - Japanese characters → Japanese (ja-JP)
   - Other non-Latin scripts → Identify accordingly

**2b. Grammar & Vocabulary Correction:**

1. **Correct grammar and vocabulary** to fit local customs and usage
2. **Ensure natural, native-like phrasing** for the source language
3. **Maintain the intended meaning** while improving clarity

### Step 3: Translation Operations

Choose the appropriate operation based on the request:

#### 3a. Add New Translation

**When user says:** "add translation key: error_text, text: something wrong with this error"

1. **Use the exact key** provided by the user (do not modify)
2. **Add the corrected source text** to the appropriate language file
3. **Translate to all other supported languages** in the project
4. **Ensure translations fit local customs** and usage patterns
5. **Verify completeness:** All languages must have the translation

#### 3b. Delete Translation

**When user says:** "delete key from translation"

1. **Remove the key and all related translations** from all language files
2. **Ensure consistency** across all translation files
3. **Verify no references remain** in the codebase

#### 3c. Update Translation Key

**When user says:** "update translation key from old_key to new_key"

1. **Rename the key** in all translation files
2. **Keep all existing translations** but with the new key name
3. **Update any code references** if necessary

#### 3d. Update Translation Text

**When user provides new text for existing key:**

1. **Update the source language** with corrected text
2. **Re-translate to all other languages** with improved accuracy
3. **Maintain key consistency** across all files

### Step 4: Comprehensive Translation Quality Review

**🔍 CRITICAL: Review entire translation file(s) for context and accuracy**

**4a. Contextual Analysis:**

- **Read through all existing translations** to understand the project's tone and style
- **Identify patterns and terminology** used throughout the project
- **Check for consistency** in similar phrases or concepts
- **Understand the domain/industry** context for better translations

**4b. Quality Improvements:**

- **Improve any translations** that don't fit the overall context
- **Standardize terminology** across all translations
- **Ensure cultural appropriateness** for each target language
- **Fix any inconsistencies** in tone or style
- **Verify technical terms** are correctly translated

**4c. Completeness Check:**

- [ ] All supported languages have translations for every key
- [ ] No missing translations (empty values)
- [ ] No extra languages beyond project requirements
- [ ] Key names are consistent across all files
- [ ] No duplicate keys within files

### Step 5: Build & Generation Procedures

**📖 Reference README.md for post-translation procedures**

**5a. Execute Required Scripts:**

```bash
# Common examples (check README.md for actual commands)
npm run build:i18n
npm run generate:translations
yarn build:locales
```

**5b. Verify Generated Files:**

- [ ] Check if any code files were generated/updated
- [ ] Verify the build process completed successfully
- [ ] Test that translations are properly loaded in the application

### Step 6: Quality Validation

**Final Checks Before Completion:**

- [ ] All requested translation operations completed
- [ ] Translation files are properly formatted
- [ ] No syntax errors in translation files
- [ ] All languages have complete translations
- [ ] Build/generation scripts executed successfully
- [ ] No breaking changes to existing functionality

**✅ Completion Criteria:**
Translation work is complete when all requested changes are implemented, all languages are properly translated, quality review is done, and build procedures are executed.

### Step 7: Documentation & Commit

**Commit Strategy:**

```bash
# For adding new translations
git commit -m "feat: add translation for error_text key #<issue-number>"

# For updating existing translations
git commit -m "refactor: update translation quality and consistency #<issue-number>"

# For deleting translations
git commit -m "refactor: remove unused translation key #<issue-number>"
```

---

## 🔧 Translation Best Practices

### Language-Specific Considerations

**English (en-US):**
- Use American spelling and conventions
- Clear, concise messaging
- Consider accessibility and readability

**Chinese (zh-CN):**
- Use simplified characters
- Consider cultural context and formality levels
- Proper punctuation (，。！？)

**Japanese (ja-JP):**
- Appropriate politeness levels (keigo)
- Consider context (formal vs casual)
- Proper particle usage

**Spanish (es-ES/es-MX):**
- Regional variations consideration
- Formal vs informal addressing
- Cultural sensitivity

### Quality Assurance

**Translation Accuracy:**
- Maintain original meaning and intent
- Adapt to local cultural context
- Use appropriate technical terminology
- Ensure consistency across the project

**Technical Considerations:**
- Respect character limits for UI elements
- Consider text expansion/contraction
- Maintain proper formatting and placeholders
- Test with actual UI components when possible

### Common Translation File Formats

**JSON Format:**
```json
{
  "error_text": "Something went wrong with this error",
  "success_message": "Operation completed successfully"
}
```

**CSV Format:**
```csv
key,en-US,zh-CN,ja-JP,es-ES
error_text,"Something went wrong","出现错误","エラーが発生しました","Algo salió mal"
success_message,"Success","成功","成功","Éxito"
```
### File Format Errors

**Problem:** Translation file has syntax errors
**Solution:**
1. Validate JSON/CSV syntax
2. Check for missing quotes, commas, or brackets
3. Ensure proper character encoding (UTF-8)

### Missing Translations

**Problem:** Some languages are missing translations
**Solution:**
1. Review all translation files for completeness
2. Add missing translations for all supported languages
3. Verify language codes are correct

### Build Script Failures

**Problem:** Generation scripts fail after translation updates
**Solution:**
1. Check README.md for correct script commands
2. Verify translation file format is correct
3. Look for error messages in build output
4. Ensure all required dependencies are installed

### Cultural Appropriateness Issues

**Problem:** Translations don't fit local customs
**Solution:**
1. Research local cultural context
2. Consult native speakers if possible
3. Review similar applications for reference
4. Test with target audience when available
