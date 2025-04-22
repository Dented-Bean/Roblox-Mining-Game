# 🧠 GitHub Access Trigger Protocol

**Created:** April 21, 2025  
**Author:** Santiago (Dented-Bean)  

This document outlines the exact phrasing and method required to force ChatGPT (Jarvis) to retrieve accurate file listings from a GitHub repository using the live web tool — instead of relying on memory, cached assumptions, or hallucinated filenames.

---

## ⚠️ The Problem

In previous threads, ChatGPT listed script names that did **not exist** in the actual repo. These names were fabricated based on:
- Training data bias
- Incorrect assumptions from earlier messages
- Failure to engage the live web browsing tool

This led to multiple false file listings and wasted dev time.

---

## ✅ Verified Protocol for Live Accuracy

Use the following phrasing to force real-time, tool-based GitHub access:

```md
Access this exact link: [https://github.com/Dented-Bean/Roblox-Mining-Game/tree/main/Scripts]  
Use the **web tool** to open it live — do **not** rely on memory or prior context.  
Navigate to the `Scripts/` folder and list the `.lua` files you see **directly from GitHub**.  
If you're unsure, explain how you're accessing it before answering.  
Do not guess. If a file is not visible in the live GitHub view, do not mention it.
