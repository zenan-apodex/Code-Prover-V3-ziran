from __future__ import annotations

import tempfile
import unittest
from pathlib import Path

from tools import benchmark_paths


REPO_ROOT = Path(__file__).resolve().parents[1]


class BenchmarkPathsTest(unittest.TestCase):
    def setUp(self) -> None:
        self.temporary = tempfile.TemporaryDirectory()
        self.root = Path(self.temporary.name)
        self.explicit = self.root / "explicit"
        self.environment = self.root / "environment"
        self.local = self.root / "local"
        for path in (self.explicit, self.environment, self.local):
            path.mkdir()
        self.config = self.root / "benchmarks.local.toml"
        self.config.write_text(
            f'schema_version = 1\n\n[sources]\ncode_prover_v2 = "{self.local}"\n',
            encoding="utf-8",
        )

    def tearDown(self) -> None:
        self.temporary.cleanup()

    def resolve(self, explicit: Path | None = None, environ=None, **kwargs) -> Path:
        return benchmark_paths.resolve_source(
            "putnambench",
            explicit,
            local_config_path=self.config,
            environ={} if environ is None else environ,
            **kwargs,
        )

    def test_explicit_path_has_highest_precedence(self) -> None:
        actual = self.resolve(
            self.explicit,
            environ={"CODE_PROVER_V2_ROOT": str(self.environment)},
        )
        self.assertEqual(actual, self.explicit.resolve())

    def test_environment_precedes_local_config(self) -> None:
        actual = self.resolve(environ={"CODE_PROVER_V2_ROOT": str(self.environment)})
        self.assertEqual(actual, self.environment.resolve())

    def test_local_config_is_fallback(self) -> None:
        self.assertEqual(self.resolve(), self.local.resolve())

    def test_invalid_higher_precedence_value_does_not_fall_back(self) -> None:
        with self.assertRaisesRegex(
            benchmark_paths.BenchmarkPathError,
            "environment variable CODE_PROVER_V2_ROOT must be absolute",
        ):
            self.resolve(environ={"CODE_PROVER_V2_ROOT": "relative/path"})

    def test_nonexistent_path_fails_clearly(self) -> None:
        missing = self.root / "missing"
        with self.assertRaisesRegex(
            benchmark_paths.BenchmarkPathError, "explicit CLI path does not exist"
        ):
            self.resolve(missing)

    def test_file_is_not_accepted_as_source_directory(self) -> None:
        source_file = self.root / "source.txt"
        source_file.write_text("not a directory", encoding="utf-8")
        with self.assertRaisesRegex(
            benchmark_paths.BenchmarkPathError, "is not a directory"
        ):
            self.resolve(source_file)

    def test_missing_configuration_lists_all_options(self) -> None:
        absent_config = self.root / "absent.toml"
        with self.assertRaises(benchmark_paths.BenchmarkPathError) as raised:
            benchmark_paths.resolve_source(
                "putnambench", local_config_path=absent_config, environ={}
            )
        message = str(raised.exception)
        self.assertIn("explicit path", message)
        self.assertIn("CODE_PROVER_V2_ROOT", message)
        self.assertIn("sources.code_prover_v2", message)

    def test_unknown_benchmark_fails_clearly(self) -> None:
        with self.assertRaisesRegex(
            benchmark_paths.BenchmarkPathError, "unknown benchmark 'unknown'"
        ):
            benchmark_paths.resolve_source("unknown", self.explicit, environ={})

    def test_registry_contains_only_relative_ignored_views(self) -> None:
        specs = benchmark_paths.load_registry()
        self.assertEqual(
            set(specs), {"putnambench", "vericoding", "verisoftbench", "vero"}
        )
        for spec in specs.values():
            self.assertFalse(spec.default_view.is_absolute())
            self.assertEqual(spec.default_view.parts[:2], ("tasks", "_campaign_views"))

    def test_default_view_is_anchored_to_repo(self) -> None:
        self.assertEqual(
            benchmark_paths.default_view("vero"),
            REPO_ROOT / "tasks/_campaign_views/vero-proof-44",
        )


if __name__ == "__main__":
    unittest.main()
