kubectl delete ns opa opa-qa opa-production || true

rm "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/../server."* || true
rm "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/../ca."* || true

