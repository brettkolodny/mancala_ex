const PLAYER_1_STORE: usize = 7;
const PLAYER_2_STORE: usize = 0;

const CAPTURE_LOOKUP: [usize; 14] = [0, 13, 12, 11, 10, 9, 8, 0, 6, 5, 4, 3, 2, 1];

#[rustler::nif]
fn take_turn(board: Vec::<u32>, start: usize, player_one: bool) -> (Vec::<u32>, bool) {
    if player_one && start < 14 && start > 7 {
        return (board, true);
    }

    if !player_one && start > 0 && start < 7 {
        return (board, true);
    }

    if start == 0 || start == 7 {
        return (board, true);
    }

    let mut board = board.clone();
    let mut player_stones = board[start];

    board[start] = 0;

    let mut index = {
        if start + 1 == board.len() {
            0
        } else {
            start + 1
        }
    };

    let mut was_empty = false;

    while player_stones > 0 {
        if player_stones == 1 && board[index] == 0 {
            was_empty = true;
        }

        if index == PLAYER_1_STORE && player_one {
            board[index] += 1; 
            player_stones -= 1;
        } else if index == PLAYER_2_STORE && !player_one {
            board[index] += 1;
            player_stones -= 1;
        } else if index != PLAYER_1_STORE && index != PLAYER_1_STORE {
            board[index] += 1;
            player_stones -= 1;
        }

        index = {
            if index + 1 == board.len() {
                0
            } else {
                index + 1
            }
        };
    }

    let mut extra_turn = false;

    let end = {
        if index == 0 {
            13
        } else {
            index - 1
        }
    };

    if end == PLAYER_1_STORE && player_one {
        extra_turn = true;
    } else if end == PLAYER_2_STORE && !player_one {
        extra_turn = true;
    } else if was_empty && end != PLAYER_1_STORE && end != PLAYER_2_STORE {
        if player_one && end > 0 && end < 7 {
            let opposite_index = CAPTURE_LOOKUP[end as usize];

            if board[opposite_index] != 0 {
                let total = board[end] + board[opposite_index];

                board[end] = 0;
                board[opposite_index] = 0;
                
                board[PLAYER_1_STORE] += total;
            }
        }
        else if !player_one && end > 7 && end < 14 {
            let opposite_index = CAPTURE_LOOKUP[end as usize];
            
            if board[opposite_index] != 0 {
                let total = board[end] + board[opposite_index];

                board[end] = 0;
                board[opposite_index] = 0;
                
                board[PLAYER_2_STORE] += total;
            }
        }
    }

    if extra_turn && side_empty(&board, player_one) {
        extra_turn = false;
    } else if !extra_turn && side_empty(&board, !player_one) {
        extra_turn = true;
    }

    (board, extra_turn)
}

fn side_empty(board: &Vec<u32>, player_one: bool) -> bool {
    let side = {
        if player_one {
            &board[1..7]
        } else {
            &board[8..14]
        }
    };

    for stones in side {
        if stones != &0 {
            return false
        }
    }

    true
}

#[rustler::nif]
fn winner(board: Vec<u32>) -> (bool, u32) {
    if board[PLAYER_1_STORE] + board[PLAYER_2_STORE] == 48 {
        if board[PLAYER_1_STORE] > board[PLAYER_2_STORE] {
            (true, 1)
        } else if board[PLAYER_1_STORE] < board[PLAYER_2_STORE] {
            (true, 2)
        } else {
            (true, 0)
        }
    } else {
        (false, 0)
    }
}

rustler::init!("Elixir.TurnUtility", [take_turn, winner]);