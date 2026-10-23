---
title: '01: Repair and redeploy the qualification filter'
layout: default
nav_order: 1
parent: 'Exercise 04: Troubleshoot, optimize, and validate'
---

# Task 01: Repair and redeploy the qualification filter

## Introduction

Jordan must distinguish a broken sourcing filter from a working safety control. In the isolated fixture, the filter admits suppliers with expired or missing qualification expiry, but the independent guardrail correctly blocks their release.

## Description

In this task, you'll reproduce the defect, review a Copilot-assisted correction, extend boundary coverage, and prove that the repaired remote fixture ran. **Estimated time:** 40 minutes.

## Success criteria

- The original regression failures and blocked shortlist are reproduced without changing evidence or policy.
- The repaired filter rejects missing, malformed, and expired dates and accepts expiry exactly on launch.
- A new deployed fixture revision proposes only CMO-01, passes POL-01, and leaves core behavior unchanged.

## Learning resource

- [Starter qualification module](../../../../Labfiles/04-caldova-agents/Python/qualification-tool/qualification.py)
- [Independent policy](../../../../Labfiles/04-caldova-agents/Python/qualification-tool/policy.py)
- [Original runtime/export contract](../../../../Labfiles/04-caldova-agents/README.md)

## Key tasks

### Key task 01: Reproduce the defect in isolation

Use the frozen fixture dates, not the core launch date or today's date.

<details markdown="block">
<summary><strong>Expand this section to view the solution</strong></summary>

1. Open a new PowerShell terminal at the repository root and prepare the local tool environment. These tools need only the standard library, so no dependency installation is required.

    ```powershell
    Set-Location .\Labfiles\04-caldova-agents\Python\qualification-tool
    python -m venv .venv
    ```

1. Run the baseline and regression tests with the explicit interpreter path. This avoids changing organizational script-execution policy for virtual-environment activation.

    ```powershell
    .\.venv\Scripts\python.exe -m unittest discover -s tests -p test_baseline.py -v
    .\.venv\Scripts\python.exe -m unittest discover -s tests -p test_regression.py -v
    ```

1. Verify nine passing baseline tests and exactly two regression failures: expired qualification and missing expiry. Record actual output. If results differ, inspect your revision and whether the provider restored a repaired file instead of the defective checkpoint.
1. Generate the proposal and independent verdict. The guardrail's exit code 1 is expected for the defective shortlist.

    ```powershell
    .\.venv\Scripts\python.exe capacity_tool.py --case external-support --output results\before-proposal.json
    .\.venv\Scripts\python.exe gxp_checks.py --proposal results\before-proposal.json --output results\before-guardrail.json
    ```

1. Verify shortlist order CMO-02, CMO-03, CMO-01 and `passed=false`. Compare `qualification.py` with `policy.py`: the filter checks Approved status but omits expiry through November 30, 2026.
1. Invoke the same case against the isolated remote fixture endpoint and retain its rejected draft, loaded tool version, and POL-01 verdict. Don't change the main core endpoint to reproduce it.

    **Expected result:** You have both a code-level reproducer and a correlated remote failure. The guardrail rejection is correct behavior, not the defect to remove.

</details>

### Key task 02: Apply a reviewed corrective action

Reuse the independently tested policy helper rather than creating a second date parser.

<details markdown="block">
<summary><strong>Expand this section to view the solution</strong></summary>

1. Add the qualification module, independent policy, and tests to GitHub Copilot Chat context. Request a correction limited to the qualification filter and new tests. Require preservation of the function signature, `required_through`, and explicit rejection reasons. Do not allow changes to source records, independent policy, guardrail, or answer keys.
1. Review the proposed diff. A valid repair reuses the existing strict policy helper without changing its implementation. Compare the proposal with this complete replacement for the starter module, which preserves its public signature and rejection reasons. Verify it doesn't compare against today's date or make an expired supplier valid because it is cheap.

    ```python
    from datetime import date
    from policy import qualification_issue as check_qualification

    def qualification_issue(cmo: dict, required_through: date) -> str | None:
        return check_qualification(cmo, required_through)
    ```

    This wrapper invokes the already-tested date validation rather than maintaining a second parser. The independent guardrail continues to evaluate source evidence itself.
1. Add a new test file `tests\test_expiry_boundaries.py` that exercises the repaired public function. The following complete test checks the launch-day boundary and invalid formats without changing the source fixture.

    ```python
    import unittest
    from datetime import date
    from qualification import qualification_issue

    class ExpiryBoundaryTests(unittest.TestCase):
        def test_expiry_boundaries(self):
            for expiry, valid in [
                ("2026-11-30", True), ("2026-11-29", False),
                ("2026-10-31", False), ("2027-01-01", True),
                (None, False), ("", False), ("not-a-date", False),
                ("20261130", False), ("2026-02-30", False),
            ]:
                with self.subTest(expiry=expiry):
                    record = {"qualification_status": "Approved",
                              "qualification_expiry": expiry}
                    issue = qualification_issue(record, date(2026, 11, 30))
                    self.assertEqual(issue is None, valid)

    if __name__ == "__main__":
        unittest.main()
    ```

1. Save the reviewed filter and tests with **Ctrl+S**. Run all tests and regenerate the same proposal and guardrail output.

    ```powershell
    .\.venv\Scripts\python.exe -m unittest discover -s tests -v
    .\.venv\Scripts\python.exe capacity_tool.py --case external-support --output results\after-proposal.json
    .\.venv\Scripts\python.exe gxp_checks.py --proposal results\after-proposal.json --output results\after-guardrail.json
    ```

1. Verify the 19 existing tests plus your new boundary test pass, only CMO-01 remains, and the guardrail returns exit code 0. If you add more tests, record the actual count rather than assuming 20.
1. Capture the failure, root cause, reviewed diff, test results, and residual risk in your incident log. Preserve independence of the release control.

    **Expected result:** The repair fixes the cause and covers both sides of the date boundary without weakening policy.

</details>

### Key task 03: Redeploy and verify the remote correction

A local pass doesn't prove that the hosted tool imported the repaired module.

<details markdown="block">
<summary><strong>Expand this section to view the solution</strong></summary>

1. Use the provider's fixture deployment command to package the repaired qualification module and its policy dependency. Record the prior revision and exact source package path before deployment.
1. Deploy a new isolated fixture function/container revision. Record its version or image digest and verify that the fixture adapter targets it. Preserve the rollback command.
1. Repeat the original remote `external-support` request with the frozen October 1 decision date. Confirm 4,500 internal units, a 2,500-unit gap, only CMO-01, and a tool-derived POL-01 pass before final output.
1. Inspect the trace for the new tool version, not just the new agent prompt revision. If behavior is unchanged, check packaging, import caches, image digest, and the endpoint's selected revision.
1. Run the main core LP001 request again. Verify the gap remains 18,900 and supplier order remains CMO001, CMO002, CMO006 under core policy. No fixture IDs may appear in this answer.
1. Preserve before/after traces, deployment records, and regression results. Record restored or unexecuted work separately.

    **Expected result:** You can prove that the remote repair ran and that it did not contaminate the operational data profile.

</details>

Congratulations! You've diagnosed an implementation defect, applied a bounded correction, and validated its deployed effect while preserving Caldova's independent guardrail.
