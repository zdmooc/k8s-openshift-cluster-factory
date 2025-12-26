#!/usr/bin/env python3
"""Capacity report helper.

Usage:
  kubectl top nodes > /tmp/top.txt
  python3 report_capacity.py /tmp/top.txt
"""

import sys
import re

def parse(line: str):
  # NAME CPU(cores) CPU% MEMORY(bytes) MEMORY%
  parts = line.split()
  if len(parts) < 5:
    return None
  name = parts[0]
  cpu_pct = parts[2].rstrip('%')
  mem_pct = parts[4].rstrip('%')
  try:
    return name, int(cpu_pct), int(mem_pct)
  except ValueError:
    return None

def main():
  if len(sys.argv) != 2:
    print("Usage: report_capacity.py <kubectl-top-nodes-output>")
    return 2
  path = sys.argv[1]
  lines = open(path, encoding="utf-8", errors="ignore").read().splitlines()
  rows = []
  for ln in lines[1:]:
    p = parse(ln)
    if p:
      rows.append(p)

  rows.sort(key=lambda x: (x[1], x[2]), reverse=True)

  print("Top nodes by CPU% then MEM%")
  for name, cpu, mem in rows[:20]:
    flag = " !!" if (cpu >= 90 or mem >= 90) else ""
    print(f"- {name:30} cpu={cpu:3d}% mem={mem:3d}%{flag}")

  return 0

if __name__ == "__main__":
  raise SystemExit(main())
