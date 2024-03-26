#!/bin/bash
echo "Running audit"
npm audit --audit-level=high --json --production > audit.json
