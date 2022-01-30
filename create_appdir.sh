#!/bin/bash
set -e

# Global settings:
user_id="3300"

app_dir="app"
binary_dir="binaries"

discovered=()

function package() {
  library="$1"

  discovered+=("$library")
  echo "Discovered: $library"

  for next_library in $(ldd "$library" 2>/dev/null | grep -E -o '=>\s(.+)\s' | awk '{print $2}'); do
    if printf '%s\0' "${discovered[@]}" | grep -Fxzq "$next_library"; then
      continue
    fi

    discovered+=("$next_library")

    if [[ "$next_library" =~ ld-linux-x86-64.so.2$ ]]; then
      continue
    fi

    directory="$app_dir/$(dirname "$next_library")"

    if ! [ -d "$directory" ]; then
      mkdir -p "$directory"
    fi

    real_path=$(realpath -e "$next_library")

    cp "$real_path" "$app_dir/$next_library"
    package "$next_library"
  done
}

function create_app_dir() {
    app_dir="$1"
    binary_dir="$2"

    rm -rf "$app_dir"
    mkdir -p "$app_dir/usr/bin" "$app_dir/lib64" "$app_dir/srv"

    chown -R "$user_id:$user_id" "$app_dir/srv"

    for executable in $(ls "$binary_dir"); do
      cp "$binary_dir/$executable" "$app_dir/usr/bin/"
      package "$binary_dir/$executable"
    done

    cp /lib64/ld-linux-x86-64.so.2 "$app_dir/lib64/"
}

create_app_dir "$app_dir" "$binary_dir"
