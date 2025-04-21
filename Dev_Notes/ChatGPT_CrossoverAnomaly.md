# 🧠 ChatGPT Crossover Anomaly Report
**Date Logged:** April 21, 2025  
**Logged By:** (Dented-Bean)  

---

## ⚠️ Summary

An unexplained anomaly occurred during the development of this project where **ChatGPT returned script file names and contents that do not exist anywhere in this repo, my Studio project, or my personal history.**

The following inconsistencies have been documented:

---

## 🧩 Anomaly #1 — `OreGlow.lua`

- On April 21, ChatGPT listed a file called `OreGlow.lua` during a live read of the `Scripts/` folder from my public GitHub repo.
- Jarvis (ChatGPT) provided the full code from the file.
- However, I have **never written**, **uploaded**, or **dragged in** a file with that name or logic.
- It was **not present** in Studio’s Explorer, and **did not appear** when searching the repo after indexing completed.
- GitHub's full-repo search and commit history show **no trace** of the file.

---

## 🧩 Anomaly #2 — Parallel Thread Listing Fake Files

In a completely separate ChatGPT thread, I gave the same instruction:
> "Access this link and list all .lua scripts in the Scripts folder."

ChatGPT responded with:
- AutoSave.lua  
- DataManager.lua  
- MiningHandler.lua  
- PlayerStats.lua  
- ToolManager.lua

These scripts were **never created, uploaded, or committed**.  
The repo was public at the time, meaning ChatGPT had live access — yet it listed **a completely different set of files** than what exists.

---

## 🧠 Context

- This project was built from a **fresh baseplate** in Studio.
- I have not used **external templates, plugins, or free models**.
- I have not **searched for or copied** any scripts from outside sources.
- I rely solely on **ChatGPT (Jarvis)** to assist with scripting and development.
- No collaborators, alternate accounts, or public forks exist under this username at time of logging.

---

## ❓ Current Hypotheses

- **GitHub caching artifact or ghost commit** that existed during public exposure
- **Parallel thread context bleed** within ChatGPT
- **Rare indexing bug or content mismatch**
- **Unknown system behavior** within ChatGPT's file parsing logic
- A literal unexplained anomaly

---

## 🔒 Action Taken

- File has been logged and preserved in `Dev_Notes/`
- Repo is being monitored for any future unexplainable changes
- Thread token usage tracked
- Project moved forward with stricter visibility checks

---

> If this file is being read by someone else in the future —  
> Just know: I didn’t imagine this. Something weird happened here.  
> And this is my receipt.

