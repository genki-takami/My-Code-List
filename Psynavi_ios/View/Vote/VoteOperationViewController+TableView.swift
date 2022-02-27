/*
 VoteOperationViewControllerの拡張
 */

import UIKit

extension VoteOperationViewController: UITableViewDataSource, UITableViewDelegate {
    
    /// セルをタップ
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return choises.count
    }
    
    /// セルの内容
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "voteChoiseCell", for: indexPath)
        
        let choise = cell.viewWithTag(1) as! UILabel
        choise.text = choises[indexPath.row]
        let selectBtn = cell.viewWithTag(2) as! UISwitch
        selectBtn.tag = indexPath.row
        selectBtn.addTarget(self, action: #selector(changeSwitch(_:forEvent:)), for: UIControl.Event.valueChanged)
        
        return cell
    }
    
    @objc func changeSwitch(_ sender: UISwitch, forEvent event: UIEvent) {
        
        /// 選択した選択肢を配列に追加・除去する
        if sender.isOn {
            /// 選択した(オンになった)
            if choiseOption {
                /// 複数選択可
                selected.append(choises[sender.tag])
            } else {
                /// 単一選択
                if self.selected.isEmpty {
                    selected.append(choises[sender.tag])
                } else {
                    /// 既に選択したものが有るにも関わらず選択した為、その選択を取り消す
                    sender.isOn = false
                    Modal.showError("この投票は複数選択できません！\n他の選択を解除して下さい")
                }
            }
        } else {
            /// 選択を解除した(オフになった)
            let choise = selected.firstIndex(of: choises[sender.tag])!
            selected.remove(at: choise)
        }
    }
}
