# industrial-air-quality-platform-mvp


Industrial Air Quality Analytics Platform

A serverless AWS project demonstrating event-driven data ingestion,
analytics, alerting and Infrastructure as Code using Terraform.

## Executive Summary 
This project demonstrates how a cloud-native serverless architecture can collect, process and analyze environmental data using AWS managed services.

The platform periodically collects PSI readings from Singapore's NEA Open Data API, stores raw data in Amazon S3, converts it into Parquet format for efficient analytics using Amazon Athena, and sends notifications when air quality crosses configurable thresholds.

The infrastructure is provisioned entirely using Terraform and can be deployed within minutes.

## Solution Architechture

                              ┌──────────────────────────────┐
                              │         GitHub Repo          │
                              │ Terraform + Python + CI/CD   │
                              └──────────────┬───────────────┘
                                             │
                              Push / Pull Request / Merge
                                             │
                                             ▼
                     ┌────────────────────────────────────────┐
                     │        GitHub Actions Pipeline         │
                     │----------------------------------------│
                     │ • Checkout Repository                  │
                     │ • Terraform Init                       │
                     │ • Terraform Validate                   │
                     │ • Terraform Plan                       │
                     │ • (Terraform Apply)                    │
                     └─────────────────┬──────────────────────┘
                                       │
                                       ▼
                    ┌──────────────────────────────────────────┐
                    │          Terraform (IaC)                 │
                    │------------------------------------------│
                    │ Provisions & Manages AWS Resources       │
                    │                                          │
                    │ • IAM Roles & Policies                   │
                    │ • Lambda Function                        │
                    │ • EventBridge Rule                       │
                    │ • S3 Buckets                             │
                    │ • CloudWatch Log Group                   │
                    └─────────────────┬────────────────────────┘
                                      │
                                      │
                                      ▼
                         AWS Runtime (Production)
                                      │
                                      │
                       Every 15 Minutes (Schedule)
                                      │
                                      ▼
                       ┌────────────────────────┐
                       │      EventBridge       │
                       │ Scheduled Rule         │
                       └───────────┬────────────┘
                                   │
                                   ▼
                      Invokes Lambda Automatically
                                   │
                                   ▼
                     ┌─────────────────────────┐
                     │   Collector Lambda      │
                     │-------------------------│
                     │ • Calls NEA API         │
                     │ • Parses JSON           │
                     │ • Creates S3 Key        │
                     │ • Uploads Object        │
                     └───────────┬─────────────┘
                                 │
              ┌──────────────────┴───────────────────┐
              │                                      │
              ▼                                      ▼
   Singapore NEA API                     CloudWatch Logs
 (Real-time PSI Endpoint)            (Execution & Errors)
              │
              │ JSON Response
              ▼
      ┌───────────────────────────┐
      │     S3 Raw Bucket          │
      │----------------------------│
      │ year=2026/                 │
      │   month=07/                │
      │      day=19/               │
      │         09:00.json         │
      │         09:15.json         │
      │         09:30.json         │
      └────────────────────────────┘
