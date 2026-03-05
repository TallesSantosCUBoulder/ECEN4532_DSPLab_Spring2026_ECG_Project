# Module 02 – ECG Project
**ECEN4532: Digital Signal Processing Laboratory (Spring 2026)**
**Instructor:** Talles Santos


## Introduction

This repository documents the design, implementation, and validation of a functional **Electrocardiogram (ECG) system** developed as part of ECEN4532 – Digital Signal Processing Laboratory.

The goal of this project is to design and build a complete ECG prototype capable of:

- Acquiring cardiac electrical signals
- Amplifying and filtering low-amplitude biopotentials
- Visualizing ECG waveforms
- Processing the signal to accurately estimate heart rate (BPM)

The project emphasizes **full hardware–software integration**, combining analog circuit design, digital signal processing, and experimental validation.

## Project Objectives

- Design and fabricate an ECG acquisition board
- Implement signal conditioning (amplification and filtering)
- Interface the hardware with software tools
- Process ECG signals to extract heart rate information
- Validate performance against a benchmark device (e.g., commercial oximeter)

## System Overview

### Hardware
- ECG analog front-end based on standard biomedical acquisition blocks
- PCB designed using **KiCad**
- Board manufactured using a **CNC machine**
- Hardware tested with an ECG signal generator and in vivo measurements

### Software
- Data acquisition using **Arduino** or **Analog Discovery 2**
- Signal processing performed in **MATLAB**
- Filtering, peak detection, and BPM estimation
- Visualization and analysis of ECG waveforms

## Repository Structure

This repository is organized to support both technical documentation and reproducibility:

- **Introduction**
  - Background on ECG systems
  - Relevant academic and technical references
- **Methodology**
  - Hardware design and implementation
  - Software development and DSP techniques
- **Results and Validation**
  - Bench testing and in vivo measurements
  - Performance comparison with reference devices
- **Conclusions and Future Work**
  - Design limitations
  - Proposed improvements

## Evaluation Criteria

- **Functional ECG Board:** 70%
- **Technical Report:** 30%

If the system is not fully functional, the maximum achievable score is 70%. In such cases, the report must thoroughly document:
- Design methodology
- Testing procedures
- Issues encountered and troubleshooting efforts

## Schedule and Deliverables

- **Due Date:** March 12, 2026
- **Presentation:** 15 minutes
  - System overview
  - Hardware and software implementation
  - Results and discussion
- **Live Demonstration**
  - Real-time ECG acquisition
  - BPM estimation from a human subject

Late submissions are not accepted unless supported by official documentation in accordance with CU Boulder policies.

---

This repository serves as both a **technical record** and a **learning resource** for biomedical signal acquisition and digital signal processing applications.