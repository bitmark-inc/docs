#!/bin/sh
#
#
cmd="tools/gh-md-toc"
github_token=""
chapter=""
subchapter=""

docs="learning-bitmark/property-system-introduction/problem-we-are-trying-to-solve.md
      learning-bitmark/quick-start/simple-solution-for-node-setup.md
      learning-bitmark/working-with-bitmarks/creating-bitmark-account.md
      learning-bitmark/working-with-bitmarks/issuing-bitmarks.md
      learning-bitmark/working-with-bitmarks/transferring-bitmarks.md
      learning-bitmark/working-with-bitmarks/using-bitmark-shares.md
      learning-bitmark/contributing-to-bitmark/bup.md
      learning-bitmark/contributing-to-bitmark/bug-bounty-program.md
      bitmark-references/node-setup/bitmark-node-setup.md
      bitmark-references/bitmark-sdk/bitmark-sdk-document.md
      bitmark-references/bitmark-sdk/account.md
      bitmark-references/bitmark-sdk/action.md
      bitmark-references/bitmark-sdk/query.md
      bitmark-references/bitmark-sdk/store_seed.md
      bitmark-references/bitmark-sdk/websocket.md
      bitmark-references/bitmark-cli/quick-setup.md
      bitmark-references/bitmark-cli/bitmark-cli.md
      bitmark-references/rpc-communication/rpc-communication.md
      bitmark-references/bitmark-node-software/bitmark-blockchain.md
      bitmark-references/bitmark-node-software/block-verification-and-synchronization.md
      bitmark-references/bitmark-node-software/node-modules.md
      bitmark-references/bitmark-node-software/mining.md
      bitmark-references/bitmark-node-software/payment-verification.md
      bitmark-references/security.md
      bitmark-references/bitmark-node-software/bitmark-shares.md
      bitmark-references/terms-and-glossary/bitmark-terms-and-glossary.md
      bitmark-appendix/bitmark-eth-comparison.md
     "

if [[ $# -lt 1 ]]; then
	echo "Usage: ./${0} <GITHUB_TOKEN>"
	exit 1
fi
github_token=${1}

# Clean up README.md
echo "" >README.md
echo "" >TOC.md

for i in $docs; do 
	echo "===> Indexing: ${i}"
	maindir=`echo ${i} | cut -d'/' -f1`
	subdir=`echo ${i} | cut -d'/' -f2`
	if [[ "${maindir}" != "${chapter}" ]]; then
		chapter=${maindir}
		echo "# ${chapter}" >>README.md
	fi

	if [[ $subdir != *.md* ]];
	then
		if [[ "${subdir}" != "${subchapter}" ]]; then
			subchapter=${subdir}
			echo "## ${subchapter}" >>README.md
		fi
	fi

	./${cmd} ./TOC.md ${i} --hide-header --hide-footer --token=${github_token} >>README.md
done
rm -f TOC.md
